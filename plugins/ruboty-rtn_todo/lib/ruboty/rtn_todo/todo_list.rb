require 'ruboty/rtn_todo/todo'
require 'forwardable'

module Ruboty
  module RtnTodo
    class TodoList
      include Enumerable
      extend Forwardable

      def_delegators :@data, :size, :empty?, :push, :<<

      def initialize
        @data = []
      end

      def sort_by_status!
        @data.sort! do |a, b|
          if a.status_id == b.status_id
            a.id <=> b.id
          else
            b.status_id <=> a.status_id
          end
        end
      end

      def done!(ids)
        @data.each { |task|
          next unless ids.include?(task.id)
          task.status = :done
        }
      end

      def cleanup!
        @data.reject!(&:done?)
      end

      def each
        @data.each { |v| yield v }
      end

      def to_s
        @data.map(&:to_s).join("\n")
      end
    end
  end
end
