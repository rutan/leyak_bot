module Handlers
  class GaroonReminder < Ruboty::Handlers::Base
    env :GAROON_CRAWL_INTERVAL, 'ガルーンをクロールする間隔(秒)'

    BRAIN_KEY = 'garoon_reminder::recent_items'

    def initialize(robot)
      super(robot)
      Thread.new { run_remind }
      Thread.new { run_fetch }
    end

    private

    def run_remind
      @timers = [
        Utils::RemindTimer.new(60 * 5, %w[
          もうすぐ時間だよ
          そろそろ時間だねぇ
          あと5分だよ
        ]),
        Utils::RemindTimer.new(60 * 1, %w[
          早くしないと間に合わないよ
          ほら、急いで！
        ])
      ]
      loop do
        remind
        sleep 30
      end
    rescue => e
      Ruboty.logger.error e.inspect
      Ruboty.logger.error e.backtrace
      sleep 5
    end

    def remind
      now = Time.now
      @timers.each do |timer|
        notify_items = recent_items.select do |schedule_item|
          next if schedule_item.allday?
          next unless schedule_item.start_at > timer.last_remind_at
          next unless (schedule_item.start_at - now) < timer.remind_sec
          true
        end
        if notify_items.size > 0
          ::Utils.notify_action(
            robot,
            message: timer.messages.sample,
            attachments: notify_items.map(&:to_attachment)
          )
        end
        timer.touch
      end
    end

    def run_fetch
      loop do
        fetch_events
        @error_count = 0
        sleep(crawl_interval)
      end
    rescue => e
      Ruboty.logger.error e.inspect
      @error_count += 1
      sleep(60 * 3 * @error_count ** 2)
    end

    def crawl_interval
      (ENV['GAROON_CRAWL_INTERVAL'] || 60 * 5).to_i
    end

    def fetch_events
      repo = Repositories::ScheduleRepository.new(robot.brain)
      recent_items = repo.fetch(Time.now.utc, Time.now.utc + 86400)
      robot.brain.data[BRAIN_KEY] = recent_items
    rescue => e
      Ruboty.logger.error e.inspect
    end

    def recent_items
      robot.brain.data[BRAIN_KEY] || []
    end
  end
end
