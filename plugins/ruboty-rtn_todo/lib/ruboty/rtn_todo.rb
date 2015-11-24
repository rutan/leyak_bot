require 'ruboty/rtn_todo/version'
require 'ruboty'
require 'ruboty/rtn_todo/store'

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
         name: 'remove_task',
         description: 'TODOを完了状態にするよ'

      def show(message)
        messages = []
        tasks = (store[message.from] ||= [])

        if tasks.size > 0
          messages << %w[
            残ってるタスクはこんな感じだよ
            はい、がんばってー
            タスク管理くらい自分でしなよ、ほら
          ].sample
          messages << '```'
          messages += tasks.map do |task|
            "- [##{task[:id]}] #{task[:content]}"
          end
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
        tasks = (store[message.from] ||= [])

        tasks.push({
                       id: generate_id(message.from),
                       content: message[:content],
                   })
        store.save
        messages << %w[
              はい、積んどいたよ
              おっけー。ちゃんと終わらせてね。
          ].sample

        message.reply(messages.join("\n"))
      end

      def remove_task(message)
        messages = []
        tasks = (store[message.from] ||= [])
        removed_tasks = remove_tasks(tasks, message[:ids].split(/\s+/))

        if removed_tasks.size > 0
          store.save
          messages << %w[
              ほい、タスクを完了状態にしたよ。おつかれ。
              タスクが終わったんだね。消しとくよ。
          ].sample
          messages << '```'
          messages += removed_tasks.map do |task|
            "- [##{task[:id]}] #{task[:content]}"
          end
          messages << '```'
        else
          messages << %w[
              ん、そんなタスクあったっけ？　なんか間違ってない？
              タスクのID教えてくれなきゃどれだかわかんないよ
          ].sample
        end

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

      # なにこれクソ
      def remove_tasks(tasks, ids)
        removed = []
        ids = ids.map { |id| id.to_s.gsub('#', '').upcase }
        tasks.delete_if do |task|
          if ids.include?(task[:id].to_s)
            removed << task
            true
          end
        end
        removed
      end
    end
  end
end
