module Handlers
  class GaroonChecker < Ruboty::Handlers::Base
    on /.*(?:(?<date>今日|本日|明日|明後日)の予定).*/,
        name: 'show',
        description: '今日の予定を持ってくるよ'

    on /.*(?:予定|ガル+ーン|ｶﾞﾙ+ｰﾝ).*(?:追加|登録|作成).*/,
        name: 'register',
        description: '予定を登録するよ'

    def show(message)
      Actions::Schedules::Show.new(message).call
    end

    def register(message)
      Actions::Schedules::Register.new(message).call
    end
  end
end
