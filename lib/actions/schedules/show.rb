module Actions
  module Schedules
    class Show < Ruboty::Actions::Base
      def call
        return if message.original[:body].match(/追加|登録|作成/)

        messages = []
        attachments = []
        date = date_from_str(message[:date])
        schedules = fetch_schedules(date)

        if schedules.size > 0
          messages << [
            "#{date.strftime("%m月%d日")}の予定はこんな感じだよ",
            "はい、#{date.strftime("%m月%d日")}の予定だよ"
          ].sample
          attachments.concat schedules.map(&:to_attachment)
        else
          messages << [
            "#{date.strftime("%m月%d日")}は特に予定無いみたいかな",
            "#{date.strftime("%m月%d日")}は予定ないみたいだよ"
          ].sample
        end
        message.reply(messages.join("\n"), attachments: attachments)
      rescue => e
        Ruboty.logger.error e.inspect
        message.reply(%w[
          あれ、なんかうまく取れないみたい
          なんかエラー画面でちゃった
        ].sample)
      end

      private

      def fetch_schedules(date = Date.today)
        repo = Repositories::ScheduleRepository.new(message.robot.brain)
        repo.fetch(date.to_time, (date + 1).to_time - 1)
      end

      def date_from_str(str)
        case str
        when '明日'
          Date.today + 1
        when '明後日'
          Date.today + 2
        when '昨日'
          Date.today - 1
        else
          Date.today
        end
      end
    end
  end
end
