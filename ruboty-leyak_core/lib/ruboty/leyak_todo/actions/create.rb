require 'ruboty/leyak_todo/actions/base'
require 'ruboty/leyak_todo/todo'

module Ruboty
  module LeyakTodo
    module Actions
      class Create < Base
        def call
          tasks.push(
              Ruboty::LeyakTodo::Todo.new(
                  id: generate_id(message.from_name),
                  content: message[:content],
                  status: :backlog,
              )
          )
          store.save

          messages << %w[
              はい、積んどいたよ
              おっけー。ちゃんと終わらせてね。
          ].sample
          message.reply(messages.join("\n"))
        end

        private

        def generate_id(from)
          key = "#{from}--index"
          n = store[key] = (store[key].to_i + 1)
          n.to_s(16).upcase
        end
      end
    end
  end
end
