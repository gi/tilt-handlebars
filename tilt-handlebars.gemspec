# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'tilt/handlebars/version'

Gem::Specification.new do |spec|
  spec.name          = "tilt-handlebars"
  spec.version       = Tilt::Handlebars::VERSION
  spec.authors       = ["Jim Cushing"]
  spec.email         = ["jimothy@mac.com"]
  spec.description   = "Use Handlebars.rb with Tilt"
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/jimothyGator/tilt-handlebars"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'tilt', '>= 1.3', '< 3'
  spec.add_dependency "handlebars", "~> 0.7"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "sinatra", "~> 1.4"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "coveralls"
end
