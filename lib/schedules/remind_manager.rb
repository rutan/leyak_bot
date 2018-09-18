
module Schedules
  class RemindManager
    @@mutex = Mutex.new

    class RemindConfig
      attr_reader :remind_sec
      attr_accessor :last_remind_at

      def initialize(remind_sec)
        @remind_sec = remind_sec
        @last_remind_at = Time.now
      end
    end

    def initialize
      @config = {
        notice: RemindConfig.new(60 * 5),
        hurry: RemindConfig.new(60 * 1)
      }
    end

    def remind(name)
      @@mutex.synchronize do
        timer = @config[name]
        return [] unless timer

        now = Time.now
        recent_items.select do |schedule_item|
          next if schedule_item.allday?

          remind_point = schedule_item.start_at - timer.remind_sec
          next if remind_point < timer.last_remind_at
          next if remind_point > now

          true
        end.tap do
          timer.last_remind_at = now
        end
      end
    end

    def fetch
      @@mutex.synchronize do
        begin
          @recent_items = ::Schedules::Client.new.fetch(Time.now.utc, Time.now.utc + 86400)
        rescue => e
          puts e.inspect
        end
      end
    end

    def recent_items
      @recent_items || []
    end

    class << self
      def instance
        @instance ||= @@mutex.synchronize { self.new }
      end
    end

    self.instance
    private_class_method(:new)
  end
end
