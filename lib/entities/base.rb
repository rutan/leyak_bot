require 'entities/base'

module Entities
  class Base
    def initialize(attrs = {})
      attrs.each do |k, v|
        public_send("#{k}=", v)
      end
    end
  end
end
