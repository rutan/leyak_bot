module Entities
  class ScheduleItem < Base
    attr_accessor :id, :url, :plan, :title, :description, :users, :start_at, :end_at, :facilities, :is_private, :is_allday

    def private?
      is_private
    end

    def allday?
      is_allday
    end

    def to_attachment
      period =
        case
        when is_allday
          '終日'
        when end_at.nil?
          "#{start_at.strftime('%R')}"
        else
          "#{start_at.strftime('%R')}〜#{end_at.strftime('%R')}"
        end
      message = [
        period,
        plan.present? ? "[#{plan}] " : nil,
        private? ? '予定あり' : title,
        facilities.present? ? "（#{facilities.join(', ')}）" : nil
      ].compact.join(' ')

      {
        fallback: message,
        title: message,
        title_link: url,
        color: '#004ea1'
      }
    end

    class << self
      def from(event)
        event = event.with_indifferent_access
        self.new(
          id: event[:id],
          url: event[:url],
          title: event[:title],
          plan: event[:plan],
          start_at: Time.parse(event[:start_at]),
          end_at: Time.parse(event[:end_at]),
          facilities: event[:facilities],
          is_private: !!event[:private],
          is_allday: !!event[:is_allday]
        )
      end
    end
  end
end
