require 'ruboty'
require 'ruboty/leyak_garoon/actions/show'
require 'ruboty/leyak_garoon/crawler'
require 'ruboty/leyak_garoon/reminder'

module Ruboty
  module LeyakGaroon
    class Handler < Ruboty::Handlers::Base
      env :GAROON_REMIND_INTERVAL, 'ガルーン通知のチェック間隔', optional: true
      env :GAROON_REMIND_SEC, 'ガルーン予定を何秒前に通知するか', optional: true
      env :GAROON_REMIND_OWNER, 'ガルーン予定を通知する先', optional: true
      env :GAROON_REMIND_CHANNEL_ID, 'ガルーン予定を通知するチャンネル', optional: false

      on /\/remind\-message\s+(?<content>.+)/m,
         name: 'remind',
         all: true,
         hidden: true

      on /(?:(?<date>今日|本日|明日|明後日)の予定)(?:\s|$)/,
         name: 'show',
         description: '今日の予定を持ってくるよ'

      def initialize(robot)
        super
        Ruboty::LeyakGaroon::Crawler.new.start
        Ruboty::LeyakGaroon::Reminder.new(robot).start
      end

      def remind(message)
        message.reply(message[:content])
      end

      def show(message)
        Ruboty::LeyakGaroon::Actions::Show.new(message).call
      end
    end
  end
end
