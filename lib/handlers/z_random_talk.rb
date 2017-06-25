require 'ruboty'

module Handlers
  class RandomTalk < Ruboty::Handlers::Base
    env :NOTIFY_OWNER, 'いろいろ通知をするときの @xxx'
    env :NOTIFY_CHANNEL, 'いろいろ通知をするときのチャンネル名'

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
