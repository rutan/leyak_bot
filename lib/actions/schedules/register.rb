require 'horai'

module Actions
  module Schedules
    class Register < Ruboty::Actions::Base
      def call
        @original_body = message.original[:body]

        if schedule_title.empty?
          message.reply(
            %w[
              なんの予定を登録するの？
              ちゃんと予定の中身も言ってくれる？
            ].sample
          )
          return
        end

        messages = []
        attachments = []
        schedule_item = register_schedule(
          title: schedule_title,
          time: schedule_time,
        )
        if schedule_item
          messages << %w[
            これでいいかな？
            予定登録したよー
            細かいところは自分でやってね
          ].sample
          attachments.push(schedule_item.to_attachment)
        else
          messages << %w[
            あれ、なんか作れないみたい
            うーん、うまくいかないから自分でやってくれない？
          ].sample
        end
        message.reply(messages.join("\n"), attachments: attachments)
      end

      private

      def schedule_time
        @schedule_time ||=
          begin
            time = schedule_horai_time
            if time.strftime('%F') != schedule_date.strftime('%F')
              time.year = schedule_date.year
              time.month = schedule_date.month
              time.day = schedule_date.day
            end
            time
          end
      end

      def schedule_date
        @schedule_date ||=
          begin
            match = @original_body.match(/(?<date>今日|明日|明後日|明々後日|(?:日|月|火|水|木|金|土)曜)/)
            date =
              case (match ? match[:date] : nil)
              when '明日'
                Date.today + 1
              when '明後日'
                Date.today + 2
              when '明々後日'
                Date.today + 3
              when '昨日'
                Date.today - 1
              when '日曜'
                next_wday(0)
              when '月曜'
                next_wday(1)
              when '火曜'
                next_wday(2)
              when '水曜'
                next_wday(3)
              when '木曜'
                next_wday(4)
              when '金曜'
                next_wday(5)
              when '土曜'
                next_wday(6)
              else
                Date.today
              end
            date.to_time
          end
      end

      def schedule_horai_time
        @schedule_horai_time ||=
          begin
            Horai::JaJP.new.parse(@original_body).to_time
          rescue => _
            schedule_date
          end
      end

      def next_wday(wday)
        today = Date.today
        if today.wday <= wday
          today + (wday - today.wday)
        else
          today + (7 - today.wday) + wday
        end
      end

      def schedule_title
        @schedule_title ||=
          begin
            match = @original_body.match(/(?:「|『|【|")(?<content>.+)(?:」|』|】|")/)
            if match
              match[:content]
            else
              ''
            end
          end
      end

      def register_schedule(title: '', time: nil)
        schedule_item = Entities::ScheduleItem.new(
          title: title,
          description: 'from @leyak_bot',
          start_at: time,
          end_at: time,
          users: users,
          is_allday: (time.hour == 0 && time.min == 0)
        )
        repo = Repositories::ScheduleRepository.new(message.robot.brain)
        repo.register(schedule_item)
      rescue => e
        Ruboty.logger.error e.inspect
        nil
      end

      def users
        [
          {id: ENV['GAROON_OWNER_ID'].to_i}
        ]
      end
    end
  end
end
