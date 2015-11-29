module Ruboty
  module RtnTodo
    module Actions
      class Base < Ruboty::Actions::Base
        private

        def messages
          @messages ||= []
        end

        def store
          @store ||= Ruboty::RtnTodo::Store.new(message.robot.brain, 'rtn_todo')
        end

        def tasks
          store[message.from] ||= Ruboty::RtnTodo::TodoList.new
        end
      end
    end
  end
end
