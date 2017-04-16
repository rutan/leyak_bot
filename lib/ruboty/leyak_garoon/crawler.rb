require 'ragoon'
require 'date'

module Ruboty
  module LeyakGaroon
    class Crawler
      class << self
        attr_accessor :events
      end

      def start
        Thread.new do
          loop do
            crawl
            sleep(crawl_interval)
          end
        end
      rescue => e
        Ruboty.logger.error e.inspect
        raise e
      end

      private

      def crawl
        Crawler.events = fetch_events
      end

      def crawl_interval
        (ENV['GAROON_CRAWL_INTERVAL'] || 60 * 5).to_i
      end

      def fetch_events
        Ragoon::Services::Schedule.new.schedule_get_events
      end
    end
  end
end
