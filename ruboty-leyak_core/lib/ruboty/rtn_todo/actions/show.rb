require 'ruboty/rtn_todo/actions/base'

module Ruboty
  module RtnTodo
    module Actions
      class Show < Base
        def call
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
      end
    end
  end
end
