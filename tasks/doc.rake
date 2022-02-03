# frozen_string_literal: true

require "yard"

YARD::Rake::YardocTask.new(:doc) do |t|
  t.options = []
  t.stats_options = ["--list-undoc"]
end
