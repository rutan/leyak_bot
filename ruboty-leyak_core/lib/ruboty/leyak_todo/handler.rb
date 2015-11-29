require 'ruboty'
require 'ruboty/leyak_todo/actions/show'
require 'ruboty/leyak_todo/actions/create'
require 'ruboty/leyak_todo/actions/doing'
require 'ruboty/leyak_todo/actions/done'
require 'ruboty/leyak_todo/actions/cleanup'

module Ruboty
  module LeyakTodo
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
        Ruboty::LeyakTodo::Actions::Show.new(message).call
      end

      def create(message)
        Ruboty::LeyakTodo::Actions::Create.new(message).call
      end

      def doing(message)
        Ruboty::LeyakTodo::Actions::Doing.new(message).call
      end

      def done(message)
        Ruboty::LeyakTodo::Actions::Done.new(message).call
      end

      def cleanup(message)
        Ruboty::LeyakTodo::Actions::CleanUp.new(message).call
      end
    end
  end
end
