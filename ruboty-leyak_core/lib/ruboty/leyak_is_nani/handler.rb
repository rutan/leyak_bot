require 'ruboty'
require 'ruboty/leyak_is_nani/image_searcher'

module Ruboty
  module LeyakIsNani
    class Handler < Ruboty::Handlers::Base
      on(
          /^(?<word>[^\s]+)\s+is\s+(?:nani|なに|何)\??/i,
          name: "is_nani",
          description: "pizza_bot",
          all: true,
      )

      def is_nani(message)
        url = ImageSearcher.new.search(message[:word])
        messages = []
        messages << "@#{message.from_name}" if message.from_name
        if url
          messages << %w[
            これのこと？
            これかなぁ
          ].sample
          messages << url
        else
          messages << %w[
            自分で調べて
          ].sample
        end
        message.reply(messages.join(' '))
      end
    end
  end
end

