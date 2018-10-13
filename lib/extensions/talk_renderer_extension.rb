require 'mobb/base'
require 'yaml'
require 'erb'
require 'ostruct'

module Extensions
  module TalkRendererExtension
    class << self
      def registered(klass)
        klass.instance_eval do
          helpers Helpers
        end
      end
    end

    def register_render_file(path)
      @render_file = YAML.load(File.read path)
    end

    def render_file
      @render_file
    end

    module Helpers
      def render(key, options = {})
        opt = options.dup
        words = self.class.render_file.dig(*key.split('.'))
        word =
          case words
          when String, Numeric
            words
          when Array
            words.sample
          else
            raise "invalid script: #{name}"
          end
        reply = opt.delete(:reply)
        locals = opt.delete(:locals) || {}
        message = ERB.new(word).result(OpenStruct.new(locals).instance_eval { binding })
        [
          "#{reply ? "@#{reply} " : ''}#{message}",
          opt
        ]
      end
    end
  end
end
