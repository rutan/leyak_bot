require 'ruboty/leyak_todo/actions/base'
require 'ruboty/leyak_todo/todo'

module Ruboty
  module LeyakTodo
    module Actions
      class Create < Base
        def call
          message[:contents].split(/\r?\n/).each do |line|
            content = line.strip.gsub(/^\-\s+/, '')
            next if content.empty? || content == '```'
            tasks.push(
                Ruboty::LeyakTodo::Todo.new(
                    id: generate_id(message.from_name),
                    content: content,
                    status: :backlog,
                )
            )
          end
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
