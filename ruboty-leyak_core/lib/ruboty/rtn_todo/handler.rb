require 'ruboty'
require 'ruboty/rtn_todo/actions/base'
require 'ruboty/rtn_todo/actions/show'
require 'ruboty/rtn_todo/actions/create'
require 'ruboty/rtn_todo/actions/doing'
require 'ruboty/rtn_todo/actions/done'
require 'ruboty/rtn_todo/actions/cleanup'

module Ruboty
  module RtnTodo
    class Handler < Ruboty::Handlers::Base
      on /(?:todo|TODO)(?:\s|$)/,
         name: 'show',
         description: '溜まっているTODOを教えてあげるよ'

      on /(?:todo|TODO):(?:\s+)(?<content>.+)$/,
         name: 'create',
         description: 'TODOを追加するよ'

      on /(?:doing|DOING):?(?<ids>(?:\s+#?[0-9A-Fa-f]+)+)$/,
         name: 'doing',
         description: 'TODOを進行状態にするよ'

      on /(?:done|DONE):?(?<ids>(?:\s+#?[0-9A-Fa-f]+)+)$/,
         name: 'done',
         description: 'TODOを完了状態にするよ'

      on /(?:todo|TODO)(?:整理|掃除|-clean)$/,
         name: 'cleanup',
         description: 'TODOの完了済みの削除するよ'

      def show(message)
        Ruboty::RtnTodo::Actions::Show.new(message).call
      end

      def create(message)
        Ruboty::RtnTodo::Actions::Create.new(message).call
      end

      def doing(message)
        Ruboty::RtnTodo::Actions::Doing.new(message).call
      end

      def done(message)
        Ruboty::RtnTodo::Actions::Done.new(message).call
      end

      def cleanup(message)
        Ruboty::RtnTodo::Actions::CleanUp.new(message).call
      end
    end
  end
end
