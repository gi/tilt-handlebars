# frozen_string_literal: true

module Fixtures
  module Helpers
    def fixture_dir
      __dir__
    end

    def fixture_data(path)
      File.read(fixture_path(path))
    end

    def fixture_file(path)
      File.open(fixture_path(path))
    end

    def fixture_path(path)
      File.expand_path(path, __dir__)
    end
  end
end
