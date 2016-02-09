require 'time'
require 'ragoon'
require 'ruboty'
require 'ruboty/leyak_garoon/entities/event'

module Ruboty
  module LeyakGaroon
    class Reminder
      def initialize(robot)
        @robot = robot
        self.last_checked_at = Time.now
      end

      attr_accessor :last_checked_at

      def start
        Thread.new do
          loop do
            check
            sleep(remind_interval)
          end
        end
      rescue => e
        puts e.inspect
      end

      private

      def check
        return unless Crawler.events

        now = Time.now
        events = Crawler.events.select do |data|
          event = Ruboty::LeyakGaroon::Entities::Event.new(data)
          next if event.all_day?
          next unless event.start_time > last_checked_at
          next unless (event.start_time - now) < remind_sec
          true
        end
        if events.size > 0
          @robot.receive(
              body: "/remind-message @#{remind_owner} もうすぐ時間だよ\n```\n#{events.join("\n")}\n```",
              from: remind_channel,
          )
        end
        self.last_checked_at = now + remind_sec
      rescue => e
        Ruboty.logger.error e.inspect
      end

      def remind_interval
        (ENV['GAROON_REMIND_INTERVAL'] || 10).to_i
      end

      def remind_sec
        (ENV['GAROON_REMIND_SEC'] || 60 * 5).to_i
      end

      def remind_owner
        (ENV['GAROON_REMIND_OWNER'] || 'ru_shalm')
      end

      def remind_channel
        ENV['GAROON_REMIND_CHANNEL_ID']
      end
    end
  end
end
