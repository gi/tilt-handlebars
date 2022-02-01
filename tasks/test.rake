# frozen_string_literal: true

require "rspec/core/rake_task"

desc "Run all tests"
task test: [:spec]

# Tasks:
# - spec: run rspec
RSpec::Core::RakeTask.new
