require 'ruboty/leyak_core/actions/base'
require 'ruboty/leyak_todo/todo_list'

module Ruboty
  module LeyakTodo
    module Actions
      class Base < Ruboty::LeyakCore::Actions::Base
        store_namespace 'leyak_todo'

        private

        def tasks
          store[message.from] ||= Ruboty::LeyakTodo::TodoList.new
        end
      end
    end
  end
end
