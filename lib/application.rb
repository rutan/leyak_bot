require 'mobb/base'
require_relative './bootstrap.rb'

class LeyakBot < Mobb::Base
  register ::Extensions::TalkRendererExtension

  # settings
  set :name, 'leyak_bot'
  set :service, 'slack' unless ENV['SLACK_TOKEN'].to_s.empty?

  register_render_file File.expand_path('../script.yml', __FILE__)

  def initialize
    super
    ::Calendars::RemindManager.instance.fetch
  end

  on /(?:^|\s*)ping$/, reply_to_me: true do
    render 'ping.pong'
  end

  on /.*(?:(?<date_str>今日|本日|明日|明後日|明々後日)の(?:予定|カレンダー)).*/, reply_to_me: true do |date_str|
    date =
      case date_str
      when '明日'
        Date.today + 1
      when '明後日'
        Date.today + 2
      when '明々後日'
        Date.today + 3
      when '昨日'
        Date.today - 1
      else
        Date.today
      end

    begin
      schedules = ::Calendars::Client.new.fetch(date.to_time, (date + 1).to_time - 1)
      if schedules.empty?
        render 'schedule.show.empty', locals: { date: date }
      else
        render 'schedule.show.present',
          locals: { date: date },
          attachments: schedules.map(&:to_attachment)
      end
    rescue => e
      puts e.inspect
      puts e.backtrace
      render 'schedule.show.failed'
    end
  end

  on /(なんじ|何時)(\?|？)/ do
    render 'time.show', locals: { time: Time.now }
  end

  on /.+/, reply_to_me: true do
    render 'talk.normal'
  end

  # 毎朝のお知らせ
  cron '0 9 * * *', dest_to: ENV['NOTIFY_CHANNEL_ID'] do
    count = 0
    begin
      date = Date.today
      schedules = ::Calendars::Client.new.fetch(date.to_time, (date + 1).to_time - 1)
      return if schedules.empty?
      render 'schedule.today',
        locals: { date: date },
        attachments: schedules.map(&:to_attachment)
    rescue => e
      puts e.inspect
      puts e.backtrace
      count += 1
      retry if count < 5
    end
  end

  # 5分前通知
  cron '* * * * *', dest_to: ENV['NOTIFY_CHANNEL_ID'] do
    begin
      items = ::Calendars::RemindManager.instance.remind(:notice)
      return nil if items.empty?

      if items.all?(&:declined?)
        render 'schedule.reminder.notice', attachments: items.map(&:to_attachment)
      else
        render 'schedule.reminder.call', attachments: items.map(&:to_attachment)
      end
    rescue => e
      puts e.inspect
    end
  end

  # 1分前通知
  cron '* * * * *', dest_to: ENV['NOTIFY_CHANNEL_ID'] do
    begin
      items = ::Calendars::RemindManager.instance.remind(:hurry)
      return nil if items.empty?
      return nil if items.all?(&:declined?)
      render 'schedule.reminder.hurry',
        attachments: items.map(&:to_attachment)
    rescue => e
      puts e.inspect
    end
  end

  # スケジュールの再取得
  cron '*/3 * * * *' do
    ::Calendars::RemindManager.instance.fetch
    nil # always nil
  end
end
