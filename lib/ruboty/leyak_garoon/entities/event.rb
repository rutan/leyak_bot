require 'time'

module Ruboty
  module LeyakGaroon
    module Entities
      class Event
        def initialize(attributes = {})
          attributes.each do |k, v|
            next unless respond_to?(k)
            public_send("#{k}=", v)
          end
        end

        attr_accessor :id, :url, :title, :start_at, :end_at, :plan, :facilities, :private, :allday

        def start_time
          @start_time ||=
              if start_at
                Time.parse(start_at)
              else
                nil
              end
        end

        def finish_time
          @finish_time ||=
              if end_at
                Time.parse(end_at)
              else
                nil
              end
        end

        def all_day?
          start_at.nil?
        end

        def period
          if start_at && end_at
            "#{start_time.strftime('%R')}〜#{finish_time.strftime('%R')}"
          else
            '終日'
          end
        end

        def private?
          !!private
        end

        def to_s
          array = []
          array << '-'
          array << format_title
          array << "\n    - #{self.url}" unless private?
          array.join(' ')
        end

        def to_attachment
          {
            fallback: format_title,
            title: format_title,
            title_link: self.url,
            color: '#004ea1'
          }
        end

        def format_title
          array = [self.period]
          if private?
            array << '予定あり'
          else
            array << "[#{self.plan}]" if self.plan.to_s.size > 0
            array << self.title
            array << "(#{self.facilities.join(' ')})" if self.facilities.size > 0
          end
          array.join(' ')
        end
      end
    end
  end
end
