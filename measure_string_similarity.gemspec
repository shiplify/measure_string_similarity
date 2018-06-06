lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name          = 'measure_string_similarity'
  s.version       = '0.1.0'
  s.date          = '2018-06-06'
  s.summary       = 'Use to measure string similarity using different distance measures and similarity measures.'
  s.description   = 'This gem is used to get a similarity value from comparing two strings.'
  s.authors       = ['Drew Smith', 'Jason Ardell']
  s.email         = ['drewsmith91@gmail.com', 'jason@agileengineeringllc.com']
  s.files         = `git ls-files`.split($/)
  s.homepage      = 'http://rubygems.org/gems/measure_string_similarity'
  s.license       = 'Shiplify'

  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 1.6'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'versionomy'
  s.add_development_dependency 'nokogiri', '~> 1.8.2'
end
