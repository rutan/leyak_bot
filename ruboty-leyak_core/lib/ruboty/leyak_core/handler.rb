require 'ruboty'

module Ruboty
  module LeyakCore
    class Handler < Ruboty::Handlers::Base
      on /.*/,
         name: 'talk',
         description: 'お話するの？',
         hidden: true,
         missing: true

      def talk(message)
        message.reply(%w[
          今忙しい
          ん、なんか用？
          なにか言った？
        ].sample)
      end
    end
  end
end
