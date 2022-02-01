# frozen_string_literal: true

require "handlebars/engine"
require "pathname"
require "tilt"

module Tilt
  # Handlebars.rb template implementation. See:
  # https://github.com/cowboyd/handlebars.rb
  # and http://handlebarsjs.com
  #
  # Handlebars is a logic-less template rendered with JavaScript.
  # Handlebars.rb is a Ruby wrapper around Handlebars, that allows
  # Handlebars templates to be rendered server side.
  #
  class HandlebarsTemplate < Template
    EXTENSIONS = ["handlebars", "hbs"].freeze

    def initialize_engine
      return if defined? ::Handlebars

      require_template_library "handlebars"
    end

    def prepare
      @engine = ::Handlebars::Engine.new
      @engine.register_partial_missing { |name| load_partial(name) }
      @template = @engine.compile(data)
    end

    # rubocop:disable Metrics/AbcSize
    def evaluate(scope, locals = {}, &block)
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

    def register_helper(*args, **opts, &block)
      @engine.register_helper(*args, **opts, &block)
    end

    def register_partial(*args, **opts, &block)
      @engine.register_partial(*args, **opts, &block)
    end

    def partial_missing(*args, **opts, &block)
      @engine.register_partial_missing(*args, **opts, &block)
    end

    def allows_script?
      false
    end

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
      raise message
    end

    private :load_partial
  end

  register HandlebarsTemplate, *HandlebarsTemplate::EXTENSIONS
end
