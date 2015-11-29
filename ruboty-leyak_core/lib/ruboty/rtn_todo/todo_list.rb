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

      def update_status!(status, ids)
        @data.each { |task|
          next unless ids.include?(task.id)
          task.status = status
        }
      end

      def doing!(ids)
        update_status!(:doing, ids)
      end

      def done!(ids)
        update_status!(:done, ids)
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
