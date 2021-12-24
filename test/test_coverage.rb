# frozen_string_literal: true

require "simplecov"
require "simplecov-cobertura"

SimpleCov.start do
  add_filter "/vendor/"

  coverage_dir "test/reports/coverage"

  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::CoberturaFormatter,
    SimpleCov::Formatter::HTMLFormatter,
  ])

  minimum_coverage 98
end
