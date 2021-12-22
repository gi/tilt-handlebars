# frozen_string_literal: true

require_relative "lib/tilt/handlebars/version"

Gem::Specification.new do |spec|
  spec.name = "tilt-handlebars"
  spec.version = Tilt::Handlebars::VERSION

  spec.authors = ["Jim Cushing", "Zach Gianos"]
  spec.email = ["jimothy@mac.com", "zach.gianos+git@gmail.com"]

  spec.summary = "Tilt support for Handlebars"
  spec.description = <<-DESCRIPTION
    tilt-handlebars allows the Handlebars template engine to work with Tilt.
    Is uses the official JavaScript implementation of Handlebars, courtesy
    of therubyracer and handlebars.rb from cowboyd.
  DESCRIPTION

  spec.homepage = "https://github.com/gi/tilt-handlebars"
  spec.license = "MIT"

  spec.metadata["changelog_uri"] = "#{spec.homepage}/RELEASE_NOTES.md"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.metadata["source_code_uri"] = spec.homepage

  spec.required_ruby_version = Gem::Requirement.new(">= 2.6")

  spec.files = `git ls-files -z`.split("\x0")
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})

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
