# frozen_string_literal: true

require "simplecov"
require "simplecov-cobertura"

return if ENV["COVERAGE"] == "false" || ENV["APPRAISAL_INITIALIZED"]

SimpleCov.start do
  add_filter "/vendor/"

  coverage_dir "spec/reports/coverage"

  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::CoberturaFormatter,
    SimpleCov::Formatter::HTMLFormatter,
  ])

  minimum_coverage 100
end
