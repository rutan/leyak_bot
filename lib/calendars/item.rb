module Calendars
  class Item
    def initialize(raw)
      @raw = raw
    end

    def private?
      @raw.visibility == 'private'
    end

    def allday?
      !!@raw.start.date
    end

    def title
      @raw.summary
    end

    def url
      @raw.html_link
    end

    def start_at
      @raw.start.date ? @raw.start.date.to_time : @raw.start.date_time.to_time
    end

    def end_at
      @raw.end.date ? @raw.end.date.to_time : @raw.end.date_time.to_time
    end

    def facilities
      return [] unless @raw.attendees
      @raw.attendees.select(&:resource).map(&:display_name)
    end

    def to_attachment
      period =
        case
        when allday?
          '終日'
        when end_at.nil?
          "#{start_at.strftime('%R')}"
        else
          "#{start_at.strftime('%R')}〜#{end_at.strftime('%R')}"
        end
      message = [
        period,
        private? ? '予定あり' : title,
        facilities.present? ? " in #{facilities.join(', ')}" : nil
      ].compact.join(' ')

      {
        fallback: message,
        title: message,
        title_link: url,
        color: '#4984ef'
      }
    end
  end
end
