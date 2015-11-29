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

        attr_accessor :title, :period, :plan, :facility, :date

        def start_time
          period_times.first
        end

        def finish_time
          period_times.last
        end

        def all_day?
          start_time.nil?
        end

        def to_s
          array = []
          array << self.period
          array << "[#{self.plan}]" if self.plan.to_s.size > 0
          array << self.title
          array << "(#{event[:facility].join(' ')})" if self.facility.size > 0
          array.join(' ')
        end

        private

        def period_times
          @period_times ||= begin
            matches = period.to_s.match(/\A(?<start>\d+:\d+)[^\d]+(?<finish>\d+:\d+)\z/)
            if matches
              [Time.parse(matches[:start]), matches[:finish]]
            else
              []
            end
          end
        end
      end
    end
  end
end
