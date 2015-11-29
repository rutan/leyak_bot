require 'ruboty/rtn_todo/actions/base'

module Ruboty
  module RtnTodo
    module Actions
      class CleanUp < Base
        def call
          tasks.cleanup!
          store.save

          if tasks.size > 0
            messages << %w[
              もう終わってるやつは片付けとくね
            ].sample
            messages << '```'
            messages << tasks.to_s
            messages << '```'
          else
            messages << %w[
              タスク全部なくなったね、おつかれ〜
            ].sample
          end
          message.reply(messages.join("\n"))
        end
      end
    end
  end
end
