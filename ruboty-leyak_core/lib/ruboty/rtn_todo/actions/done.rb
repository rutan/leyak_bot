require 'ruboty/rtn_todo/actions/base'

module Ruboty
  module RtnTodo
    module Actions
      class Done < Base
        def call
          return if tasks.empty?

          ids = message[:ids].split(/\s+/).map { |n| n.gsub('#', '').upcase }

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
      end
    end
  end
end
