require 'ruboty'
require 'ruboty/rtn_garoon/actions/show'

module Ruboty
  module RtnGaroon
    class Handler < Ruboty::Handlers::Base
      on /(?:(?<date>今日|本日|明日|明後日)の予定)(?:\s|$)/,
         name: 'show',
         description: '今日の予定を持ってくるよ'

      def show(message)
        Ruboty::RtnGaroon::Actions::Show.new(message).call
      end
    end
  end
end
