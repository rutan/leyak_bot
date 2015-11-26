require 'ruboty/rtn_todo/actions/base'

module Ruboty
  module RtnTodo
    module Actions
      class Doing < Base
        def call
          return if tasks.empty?

          ids = message[:ids].split(/\s+/).map { |n| n.gsub('#', '').upcase }

          tasks.doing!(ids)
          tasks.sort_by_status!
          store.save

          messages << %w[
              がんば
              はやく終わらせてよねー
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
