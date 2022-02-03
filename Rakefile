# frozen_string_literal: true

Dir.glob("tasks/**/*.rake") do |file|
  import(file)
end

task default: [:clobber, :test]
