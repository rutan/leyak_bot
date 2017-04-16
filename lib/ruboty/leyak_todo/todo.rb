module Ruboty
  module LeyakTodo
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
        status_str =
          case status
          when :done;
            '[done] '
          when :doing;
            '(doing) '
          else
            ''
          end
        "##{id} #{status_str}#{content}"
      end

      STATUS = {
          backlog: 0,
          doing: 1,
          done: 2,
      }
    end
  end
end
