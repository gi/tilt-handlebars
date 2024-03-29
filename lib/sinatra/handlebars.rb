# frozen_string_literal: true

require "tilt/handlebars"

module Sinatra
  module Handlebars
    def handlebars(*args)
      render(:handlebars, *args)
    end
  end

  helpers Handlebars
end
