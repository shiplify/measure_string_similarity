lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name          = 'measure_string_similarity'
  s.version       = '0.4.9'
  s.date          = '2023-03-10'
  s.summary       = 'Use to measure string similarity using different distance measures and similarity measures.'
  s.description   = 'This gem is used to get a similarity value from comparing two strings.'
  s.authors       = ['Drew Smith', 'Jason Ardell']
  s.email         = ['drewsmith91@gmail.com', 'jason@agileengineeringllc.com']
  s.files         = `git ls-files`.split($/)
  s.homepage      = 'http://rubygems.org/gems/measure_string_similarity'
  s.licenses      = ['MIT']

  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 2'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'versionomy'
  s.add_development_dependency 'nokogiri', '~> 1.14'
end
