require 'pathname'
require 'tilt' unless defined? Tilt
require 'handlebars'

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
    def initialize_engine
      return if defined? ::Handlebars
      require_template_library 'handlebars'
    end    

    def prepare
      @context = ::Handlebars::Context.new
      @context.partial_missing { |partial_name| load_partial partial_name }
      @template = @context.compile(data)
    end


    def evaluate(scope, locals = {}, &block)
      # Based on LiquidTemplate
      locals = locals.inject({}){ |h,(k,v)| h[k.to_s] = v ; h }
      if scope.respond_to?(:to_h)
        scope  = scope.to_h.inject({}){ |h,(k,v)| h[k.to_s] = v ; h }
        locals = scope.merge(locals)
      else
        scope.instance_variables.each do |var|
          key = var.to_s.delete("@")
          locals[key] = scope.instance_variable_get(var) unless locals.has_key? key
        end
      end

      locals['yield'] = block.nil? ? '' : yield
      locals['content'] = locals['yield']

      @template.call(locals);
    end

    def register_helper(name, &fn)
      @context.register_helper(name, &fn)
    end

    def register_partial(*args)
      @context.register_partial(*args)
    end

    def partial_missing(&fn)
      @context.partial_missing(&fn)
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

      partial_file = File.expand_path("#{partial_name}.hbs", dir)
      partial_file = File.expand_path("#{partial_name}.handlebars", dir) unless File.file? partial_file
      if File.file? partial_file
        return IO.read(partial_file)
      end

      raise "The partial '#{partial_name}' could not be found. No such file #{partial_file}"
    end

    private :load_partial
    
  end

  register HandlebarsTemplate, 'handlebars', 'hbs'
end


