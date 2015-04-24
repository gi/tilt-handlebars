# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'tilt/handlebars/version'

Gem::Specification.new do |spec|
  spec.name          = "tilt-handlebars"
  spec.version       = Tilt::Handlebars::VERSION
  spec.authors       = ["Jim Cushing"]
  spec.email         = ["jimothy@mac.com"]
  spec.description = <<-EOF
    tilt-handlebars allows the Handlebars template engine to work with Tilt.
    Is uses the official JavaScript implementation of Handlebars, courtesy
    of therubyracer and handlebars.rb from cowboyd.
  EOF
  spec.summary       = "Tilt support for Handlebars"
  spec.homepage      = "https://github.com/jimothyGator/tilt-handlebars"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'tilt', '>= 1.3', '< 3'
  spec.add_dependency "handlebars", "~> 0.7"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "sinatra", "~> 1.4"
  spec.add_development_dependency "rack-test", "~> 0.6"
  spec.add_development_dependency "coveralls", "~> 0.6"
end
