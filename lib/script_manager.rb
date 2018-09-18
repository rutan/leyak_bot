require 'erb'
require 'yaml'
require 'ostruct'

class ScriptManager
  def initialize(hash)
    @hash = hash
  end

  def render(name, locals = {})
    words = @hash.dig(*name.split('.'))
    word =
      case words
      when String, Numeric
        words
      when Array
        words.sample
      else
        raise "invalid script: #{name}"
      end
    ERB.new(word).result(OpenStruct.new(locals).instance_eval { binding })
  end

  class << self
    def load_yaml(path)
      puts "load: #{path}"
      new(YAML.load(File.read(path)))
    end
  end
end
