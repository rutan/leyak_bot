require 'ruboty'

module Ruboty
  module RtnTodo
    class Store
      include Enumerable

      def initialize(brain, namespace)
        @brain = brain
        @namespace = namespace
        @data = (brain.data[namespace] || {})
      end

      attr_reader :brain, :namespace

      def [](key)
        @data[key]
      end

      def []=(key, value)
        @data[key] = value
      end

      def each
        @data.each { |k, v| yield(k, v) }
      end

      def save
        brain.data[namespace] = @data
      end
    end
  end
end
