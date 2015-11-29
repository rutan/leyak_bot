require 'ruboty/rtn_todo/actions/base'

module Ruboty
  module RtnTodo
    module Actions
      class Create < Base
        def call
          tasks.push(
              Ruboty::RtnTodo::Todo.new(
                  id: generate_id(message.from),
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
