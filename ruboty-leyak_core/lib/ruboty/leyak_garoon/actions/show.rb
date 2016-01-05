require 'date'
require 'ragoon'
require 'ruboty/leyak_garoon/actions/base'

module Ruboty
  module LeyakGaroon
    module Actions
      class Show < Base
        def call
          date = date_from_str(message[:date])
          events = fetch_events(date)

          if events.size > 0
            messages << "#{date.strftime("%m/%d")}の予定はこんな感じだよ"
            #messages << '```'
            messages << events.map { |n| Ruboty::LeyakGaroon::Entities::Event.new(n).to_s }
            #messages << '```'
          else
            messages << "#{date.strftime("%m/%d")}は特に予定無いみたいかな"
          end
          message.reply(messages.join("\n"))
        end

        private

        def schedule_service
          @schedule_service ||= Ragoon::Services::Schedule.new
        end

        def fetch_events(date = Date.today)
          schedule_service.schedule_get_events(Ragoon::Services.start_and_end(date))
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
end
