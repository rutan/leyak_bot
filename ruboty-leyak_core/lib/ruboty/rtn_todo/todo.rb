module Ruboty
  module RtnTodo
    class Todo
      def initialize(attributes = {})
        attributes.each { |k, v| public_send("#{k}=", v) }
      end

      attr_accessor :id, :content, :status

      def status_id
        STATUS[status].to_i
      end

      def backlog?
        status == :backlog
      end

      def doing?
        status == :doing
      end

      def done?
        status == :done
      end

      def to_s
        n =
          case status
          when :done;
            'x'
          when :doing;
            'o'
          else
            ; ' '
          end
        "[#{n}] ##{id} #{content}"
      end

      STATUS = {
          backlog: 0,
          doing: 1,
          done: 2,
      }
    end
  end
end
