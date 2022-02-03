# frozen_string_literal: true

require "handlebars/engine"
require "pathname"
require "tilt"

module Tilt
  module Handlebars
    class Error < RuntimeError; end
  end

  # A Tilt interface for the official JavaScript implementation of the
  # Handlebars.js template engine.
  #
  # @see https://github.com/rtomayko/tilt
  # @see https://handlebarsjs.com
  class HandlebarsTemplate < Template
    EXTENSIONS = ["handlebars", "hbs"].freeze

    # Loads the template engine, if necessary.
    #
    # This method is needed in Tilt 1 but was removed in Tilt 2. It is provided
    # here for backwards compatibility.
    # @see https://github.com/rtomayko/tilt/blob/tilt-1/lib/tilt/template.rb#L58
    def initialize_engine; end

    def prepare
      @engine = ::Handlebars::Engine.new(**options.slice(:lazy, :path))
      @engine.register_partial_missing { |name| load_partial(name) }
      @template = @engine.compile(data)
    end

    # rubocop:disable Metrics/AbcSize
    def evaluate(scope, locals, &block)
      # Based on LiquidTemplate
      locals = locals.transform_keys(&:to_s)
      if scope.respond_to?(:to_h)
        scope = scope.to_h.transform_keys(&:to_s)
        locals = scope.merge(locals)
      else
        scope.instance_variables.each do |var|
          key = var.to_s.delete("@")
          locals[key] = scope.instance_variable_get(var) unless locals.key? key
        end
      end

      locals["yield"] = block.nil? ? "" : yield
      locals["content"] = locals["yield"]

      @template.call(locals)
    end
    # rubocop:enable Metrics/AbcSize

    def partial_missing(*args, **opts, &block)
      @engine.register_partial_missing(*args, **opts, &block)
    end

    def allows_script?
      false
    end

    private

    def load_partial(partial_name)
      if Pathname.new(partial_name).absolute?
        dir = ""
      elsif file
        dir = File.dirname file
      end

      paths = EXTENSIONS.map { |ext|
        File.expand_path("#{partial_name}.#{ext}", dir)
      }
      path = paths.find { |p|
        File.file?(p)
      }

      return File.read(path) if path

      message =
        "The partial '#{partial_name}' could not be found. No such files "\
        "#{paths.join(", ")}"
      raise Handlebars::Error, message
    end

    def method_missing(name, *args, &block)
      @engine.send(name, *args, &block)
    end

    def respond_to_missing?(name, *)
      @engine.respond_to?(name) || super
    end
  end

  register HandlebarsTemplate, *HandlebarsTemplate::EXTENSIONS
end
