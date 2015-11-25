require 'ruboty/rtn_todo/version'
require 'ruboty'
require 'ruboty/rtn_todo/store'
require 'ruboty/rtn_todo/todo'
require 'ruboty/rtn_todo/todo_list'

module Ruboty
  module Handlers
    class RtnTodo < Base
      on /(?:todo|TODO)(?:\s|$)/,
         name: 'show',
         description: '溜まっているTODOを教えてあげるよ'

      on /(?:todo|TODO):(?:\s+)(?<content>.+)$/,
         name: 'add_task',
         description: 'TODOを追加するよ'

      on /(?:done|DONE):?(?<ids>(?:\s+#?[0-9A-Fa-f]+)+)$/,
         name: 'done_task',
         description: 'TODOを完了状態にするよ'

      on /(?:todo|TODO)(?:整理|掃除|-clean)$/,
         name: 'cleanup',
         description: 'TODOの完了済みの削除するよ'

      def show(message)
        messages = []
        tasks = (store[message.from] ||= Ruboty::RtnTodo::TodoList.new)

        if tasks.size > 0
          messages << %w[
            残ってるタスクはこんな感じだよ
            はい、がんばってー
            タスク管理くらい自分でしなよ、ほら
          ].sample
          messages << '```'
          messages << tasks.to_s
          messages << '```'
        else
          messages << %w[
            残ってるタスクは無さそうかな、おつかれ
          ].sample
        end

        message.reply(messages.join("\n"))
      end

      def add_task(message)
        messages = []
        tasks = (store[message.from] ||= Ruboty::RtnTodo::TodoList.new)

        tasks.push(Ruboty::RtnTodo::Todo.new(
                       id: generate_id(message.from),
                       content: message[:content],
                       status: :backlog,
                   ))
        store.save
        messages << %w[
              はい、積んどいたよ
              おっけー。ちゃんと終わらせてね。
          ].sample

        message.reply(messages.join("\n"))
      end

      def done_task(message)
        messages = []
        ids = message[:ids].split(/\s+/).map { |n| n.gsub('#', '').upcase }
        tasks = (store[message.from] ||= Ruboty::RtnTodo::TodoList.new)
        tasks.done!(ids)
        tasks.sort_by_status!
        store.save
        messages << %w[
              ほい、タスクを完了状態にしたよ。おつかれ。
              タスクが終わったんだね。
          ].sample
        messages << '```'
        messages << tasks.to_s
        messages << '```'
        message.reply(messages.join("\n"))
      end

      def cleanup(message)
        messages = []
        tasks = (store[message.from] ||= Ruboty::RtnTodo::TodoList.new)
        tasks.cleanup!
        store.save
        messages << %w[
            もう終わってるやつは片付けとくね
          ].sample
        messages << '```'
        messages << tasks.to_s
        messages << '```'
        message.reply(messages.join("\n"))
      end

      private

      def store
        @store ||= Ruboty::RtnTodo::Store.new(robot.brain, 'rtn_todo')
      end

      def generate_id(from)
        key = "#{from}--index"
        n = store[key] = (store[key].to_i + 1)
        n.to_s(16).upcase
      end
    end
  end
end
