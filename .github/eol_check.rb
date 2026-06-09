#!/usr/bin/env ruby
# frozen_string_literal: true

# EOL check against endoflife.date for language runtimes, frameworks, and
# key dependencies declared in a repo.
#
# Ships with built-in detectors for the common cases (Ruby, Python, Node,
# Rails, React, Bootstrap, pnpm, PostgreSQL, NumPy, Debian, OpenTofu).
# Each detector auto-skips if its source file is missing -- so the action
# is safe to drop in to any repo with no config.
#
# Optional config at .github/eol-check.yml in the caller repo:
#
#   warn_days: 60                       # default 90
#   disable: [Bootstrap, React]         # turn off built-in detectors by name
#   extra_checks:
#     - name: SciPy
#       product: scipy
#       file: uv.lock                   # single literal path
#       pattern: 'name = "scipy"\nversion = "([0-9]+\.[0-9]+)'
#     - name: Alpine
#       product: alpine
#       glob: containers/*/Dockerfile   # OR a Dir.glob pattern
#       pattern: 'alpine:([0-9]+\.[0-9]+)'
#
# Stdlib only -- runs on the preinstalled Ruby on ubuntu-latest, no
# Bundler / Gemfile reads.

require 'date'
require 'json'
require 'net/http'
require 'optparse'
require 'time'
require 'uri'
require 'yaml'

DEFAULT_WARN_DAYS = 90
ENDOFLIFE_API = 'https://endoflife.date/api'

# Built-in detectors. Each entry runs the listed `pattern` against
# either `file:` (a single path) or `glob:` (a Dir.glob pattern; the
# first matching file whose contents also match `pattern` wins) and
# uses capture group 1 as the version. A detector with no matching
# file is silently skipped. `name` is the human-readable label and the
# key used by `disable:` in caller config. `remap:` translates a
# captured token (e.g. a Debian codename) to the value endoflife.date
# expects (its cycle number).
BUILTIN_DETECTORS = [
  { name: 'Ruby',       product: 'ruby',       file: '.ruby-version',
    pattern: /^([0-9]+\.[0-9]+)/ },
  { name: 'Python',     product: 'python',     file: '.python-version',
    pattern: /^([0-9]+\.[0-9]+)/ },
  { name: 'Node.js',    product: 'nodejs',     file: '.node-version',
    pattern: /^([0-9]+)/ },
  # Fallback for repos without .node-version: read engines.node / packageManager.
  { name: 'Node.js (package.json)', product: 'nodejs', file: 'package.json',
    pattern: /"node":\s*"\^?([0-9]+)/, fallback_for: 'Node.js' },
  { name: 'Rails',      product: 'rails',      file: 'Gemfile',
    pattern: /gem ['"]rails['"],\s*['"]~>\s*([0-9]+\.[0-9]+)/ },
  { name: 'React',      product: 'react',      file: 'package.json',
    pattern: /"react":\s*"\^?([0-9]+)/ },
  { name: 'Bootstrap',  product: 'bootstrap',  file: 'package.json',
    pattern: /"bootstrap":\s*"\^?([0-9]+)/ },
  { name: 'pnpm',       product: 'pnpm',       file: 'package.json',
    pattern: /"packageManager":\s*"pnpm@([0-9]+)/ },
  { name: 'PostgreSQL', product: 'postgresql', file: 'docker-compose.yml',
    pattern: %r{(?:postgres|postgis/postgis):([0-9]+)} },
  { name: 'NumPy',      product: 'numpy',      file: 'uv.lock',
    pattern: /^name = "numpy"\r?\nversion = "([0-9]+\.[0-9]+)/ },
  # Debian's endoflife.date cycle is the major version number, not the
  # codename, so remap the codename captured from `python:<v>-<codename>`
  # base-image references in any containers/*/Dockerfile.
  #
  # The pattern's optional `-slim` non-capturing group is important: the
  # naive `python:[0-9.]+-([a-z]+)` would capture "slim" out of
  # `python:3.12-slim-bookworm`, then fail to remap. Other non-Debian
  # variants (alpine, windowsservercore) capture a non-codename string
  # which the stricter remap below filters out as a no-match.
  { name: 'Debian',     product: 'debian',     glob: 'containers/*/Dockerfile',
    pattern: /python:[0-9.]+(?:-slim)?-([a-z]+)/,
    remap: {
      'bullseye' => '11',
      'bookworm' => '12',
      'trixie'   => '13',
      'forky'    => '14',
    } },
  # OpenTofu and Terraform share `required_version` syntax in
  # `versions.tf`. Shiplify standardized on OpenTofu, so we query the
  # opentofu endoflife.date product. The pattern tolerates any
  # constraint operator (~>, >=, =, etc.) by skipping non-digits between
  # the opening quote and the version.
  { name: 'OpenTofu',   product: 'opentofu',   glob: '**/versions.tf',
    pattern: /required_version\s*=\s*"[^0-9]*([0-9]+\.[0-9]+)/ },
].freeze

Result = Struct.new(:status, :name, :product, :version, :message, keyword_init: true)

def parse_args(argv)
  options = { config: '.github/eol-check.yml', warn_days: nil }
  OptionParser.new do |opts|
    opts.on('--config PATH') { |v| options[:config] = v }
    opts.on('--warn-days N', Integer) { |v| options[:warn_days] = v }
  end.parse!(argv)
  options
end

def load_config(path)
  return {} unless File.exist?(path)
  if YAML.respond_to?(:safe_load_file)
    YAML.safe_load_file(path) || {}
  else
    YAML.safe_load(File.read(path)) || {}
  end
end

def resolve_warn_days(cli_value, config)
  return cli_value if cli_value
  v = config['warn_days']
  return v.to_i if v
  DEFAULT_WARN_DAYS
end

# Build the active detector list: built-ins minus disabled, plus extras
# from config. Extras come from YAML so we compile their patterns here.
def active_detectors(config)
  disabled = (config['disable'] || []).map(&:to_s)
  builtins = BUILTIN_DETECTORS.reject { |d| disabled.include?(d[:name]) }
  extras = (config['extra_checks'] || []).map do |c|
    {
      name: c['name'].to_s,
      product: c['product'].to_s,
      file: c['file'] ? c['file'].to_s : nil,
      glob: c['glob'] ? c['glob'].to_s : nil,
      pattern: Regexp.new(c['pattern'].to_s),
      remap: (c['remap'] || {}).transform_keys(&:to_s),
    }
  end
  builtins + extras
end

def extract_version(detector)
  paths = detector_paths(detector)
  paths.each do |path|
    next unless File.exist?(path)
    contents = File.read(path)
    m = contents.match(detector[:pattern])
    next unless m && m[1]
    raw = m[1]
    remap = detector[:remap]
    # When a remap is declared, treat it as an enum: a captured value
    # not present in the remap is a no-match (return nil) rather than a
    # passthrough. This prevents non-Debian codenames captured by the
    # Debian detector (e.g. "alpine" from `python:3.13-alpine`) from
    # being sent to endoflife.date/debian/alpine as a false positive.
    if remap
      next unless remap.key?(raw)
      return remap[raw]
    end
    return raw
  end
  nil
end

# Resolve the candidate paths for a detector: either the literal `file:`
# entry, or every match of the `glob:` (sorted for determinism). At most
# one of `file:` and `glob:` should be set.
def detector_paths(detector)
  return [detector[:file]] if detector[:file]
  return Dir.glob(detector[:glob]).sort if detector[:glob]
  []
end

def http_get_json(url)
  uri = URI(url)
  req = Net::HTTP::Get.new(uri)
  req['User-Agent'] = 'shiplify-eol-check/1.0'
  req['Accept'] = 'application/json'
  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https',
                        open_timeout: 10, read_timeout: 15) do |http|
    http.request(req)
  end
  return nil unless res.is_a?(Net::HTTPSuccess)
  JSON.parse(res.body)
rescue StandardError => e
  warn "  ! network error fetching #{url}: #{e.class}: #{e.message}"
  nil
end

def check_eol(detector, version, warn_days)
  data = http_get_json("#{ENDOFLIFE_API}/#{detector[:product]}/#{version}.json")
  if data.nil?
    return Result.new(status: :warn, name: detector[:name], product: detector[:product],
                      version: version, message: 'could not fetch EOL data')
  end
  eol_value = data['eol']
  if eol_value == false || eol_value.nil?
    return Result.new(status: :ok, name: detector[:name], product: detector[:product],
                      version: version, message: 'no EOL date set')
  end
  eol_date = Date.parse(eol_value.to_s)
  days_left = (eol_date - Date.today).to_i
  if days_left.negative?
    Result.new(status: :fail, name: detector[:name], product: detector[:product],
               version: version, message: "ALREADY EOL (since #{eol_date})")
  elsif days_left < warn_days
    Result.new(status: :fail, name: detector[:name], product: detector[:product],
               version: version, message: "EOL in #{days_left} days (#{eol_date})")
  else
    Result.new(status: :ok, name: detector[:name], product: detector[:product],
               version: version, message: "EOL in #{days_left} days (#{eol_date})")
  end
end

def write_summary(lines)
  path = ENV['GITHUB_STEP_SUMMARY']
  return unless path && !path.empty?
  File.open(path, 'a') { |f| f.puts(lines.join("\n")) }
end

def icon(status)
  { ok: '✅', warn: '⚠️ ', fail: '🔴' }[status]
end

def main(argv)
  options = parse_args(argv)
  config = load_config(options[:config])
  warn_days = resolve_warn_days(options[:warn_days], config)

  detectors = active_detectors(config)

  # Resolve fallbacks: if a detector with `fallback_for: X` finds a
  # version and X also matched, we keep X. If X did NOT match (e.g. no
  # .node-version), the fallback's result stands in.
  primary_results = []
  fallback_pool = []
  detectors.each do |d|
    if d[:fallback_for]
      fallback_pool << d
    else
      version = extract_version(d)
      primary_results << [d, version]
    end
  end

  matched_names = primary_results.select { |_, v| v }.map { |d, _| d[:name] }
  fallback_pool.each do |d|
    next if matched_names.include?(d[:fallback_for])
    version = extract_version(d)
    next unless version
    # Re-label the fallback under the canonical name so output is clean.
    primary_results << [d.merge(name: d[:fallback_for]), version]
  end

  summary_lines = ['## EOL Check Results', '']
  failed = false
  found_any = false
  primary_results.each do |detector, version|
    if version.nil?
      next
    end
    found_any = true
    result = check_eol(detector, version, warn_days)
    line = "#{icon(result.status)} #{result.name} #{result.version}: #{result.message}"
    puts line
    summary_lines << "- #{line}"
    failed = true if result.status == :fail
  end

  if !found_any
    msg = 'No EOL detectors matched any files in this repo.'
    puts msg
    summary_lines << msg
  end

  write_summary(summary_lines)

  if failed
    puts ''
    puts '❌ One or more dependencies are within the EOL warning window or already expired!'
    return 1
  end
  0
end

exit(main(ARGV)) if $PROGRAM_NAME == __FILE__
