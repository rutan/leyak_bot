require 'ruboty'

module Handlers
  class RandomTalk < Ruboty::Handlers::Base
    on /.*/,
       name: 'talk',
       description: 'お話するの？',
       hidden: true,
       missing: true

    LIST = %w(
        今忙しい
        ん、なんか用かな？
        なーに？
    )

    def talk(message)
      message.reply(LIST.sample)
    end
  end
end
