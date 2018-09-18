require 'mobb/base'
require_relative './bootstrap.rb'

class LeyakBot < Mobb::Base
  register ::Extensions::TalkRendererExtension

  # settings
  set :service, 'slack' unless ENV['SLACK_TOKEN'].to_s.empty?
  set :name, 'leyak_bot'

  register_render_file File.expand_path('../script.yml', __FILE__)

  def initialize
    super
    ::Schedules::RemindManager.instance.fetch
  end

  on /(?:^|\s*)ping$/, ignore_bot: true, reply_to_me: true do
    render 'ping.pong'
  end

  on /.*(?:予定|ガル+ーン|ｶﾞﾙ+ｰﾝ).*(?:追加|登録|作成).*/, ignore_bot: true, reply_to_me: true do
    begin
      schedule = Schedules::RegisterTask.new.call(@env.body)
      ::Schedules::RemindManager.instance.fetch
      render 'schedule.register.success',
        attachments: [schedule.to_attachment]
    rescue Schedules::RegisterTask::EmptyTitleError
      render 'schedule.register.empty_title'
    rescue => e
      puts e.inspect
      render 'schedule.register.failed'
    end
  end

  on /.*(?:(?<date_str>今日|本日|明日|明後日)の予定).*/, ignore_bot: true, reply_to_me: true do |date_str|
    date =
      case date_str
      when '明日'
        Date.today + 1
      when '明後日'
        Date.today + 2
      when '昨日'
        Date.today - 1
      else
        Date.today
      end

    begin
      schedules = ::Schedules::Client.new.fetch(date.to_time, (date + 1).to_time - 1)
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

  on /.+/, ignore_bot: true, reply_to_me: true do
    render 'talk.normal'
  end

  # 毎朝のお知らせ
  cron '0 9 * * *', dest_to: ENV['NOTIFY_CHANNEL_ID'] do
    count = 0
    begin
      date = Date.today
      schedules = ::Schedules::Client.new.fetch(date.to_time, (date + 1).to_time - 1)
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
    items = ::Schedules::RemindManager.instance.remind(:notice)
    return nil if items.empty?
    begin
      render 'schedule.reminder.notice',
        attachments: items.map(&:to_attachment)
    rescue => e
      puts e.inspect
    end
  end

  # 1分前通知
  cron '* * * * *', dest_to: ENV['NOTIFY_CHANNEL_ID'] do
    items = ::Schedules::RemindManager.instance.remind(:hurry)
    return nil if items.empty?
    begin
      render 'schedule.reminder.hurry',
        attachments: items.map(&:to_attachment)
    rescue => e
      puts e.inspect
    end
  end

  # スケジュールの再取得
  cron '*/3 * * * *' do
    ::Schedules::RemindManager.instance.fetch
    nil # always nil
  end
end
