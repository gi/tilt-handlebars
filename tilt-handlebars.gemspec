# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "English"
require "tilt/handlebars/version"

Gem::Specification.new do |spec|
  spec.name = "tilt-handlebars"
  spec.version = Tilt::Handlebars::VERSION
  spec.authors = ["Jim Cushing"]
  spec.email = ["jimothy@mac.com"]
  spec.description = <<-DESCRIPTION
    tilt-handlebars allows the Handlebars template engine to work with Tilt.
    Is uses the official JavaScript implementation of Handlebars, courtesy
    of therubyracer and handlebars.rb from cowboyd.
  DESCRIPTION
  spec.summary = "Tilt support for Handlebars"
  spec.homepage = "https://github.com/jimothyGator/tilt-handlebars"
  spec.license = "MIT"

  spec.metadata["rubygems_mfa_required"] = "true"

  spec.required_ruby_version = Gem::Requirement.new(">= 2.6")

  spec.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "handlebars", "~> 0.7"
  spec.add_dependency "tilt", ">= 1.3", "< 3"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rack-test", "~> 0.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rake"
  spec.add_development_dependency "sinatra", "~> 1.4"
end
