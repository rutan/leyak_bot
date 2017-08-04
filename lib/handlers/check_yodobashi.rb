require 'json'
require 'digest/md5'
require 'ruboty'
require 'chrono'
require 'rest-client'
require 'nokogiri'

module Handlers
  # ヨドバシドットコムの在庫を監視する
  class CheckYodobashi < Ruboty::Handlers::Base
    env :NOTIFY_YODOBASHI_CHANNEL, '在庫情報を通知するチャンネル', optional: false
    env :NOTIFY_YODOBASHI_OWNER, '在庫情報を通知する相手', optional: false

    # TODO: 外部から設定できるようにするぞ！
    TARGETS = [
      {
        name: 'Nintendo Switch',
        url: 'http://www.yodobashi.com/Nintendo-Switch%E7%94%A8%E3%82%B2%E3%83%BC%E3%83%A0%E6%A9%9F%E6%9C%AC%E4%BD%93/ct/269013_000000000000001848/'
      }
    ]

    def initialize(robot)
      super(robot)
      @notify_cache = {}
      start_crawler
    end

    private

    def start_crawler
      @thread = Thread.new do
        Chrono::Trigger.new('*/2 * * * *') {
          begin
            notify_channel(select_require_notify(fetch))
          rescue => e
            puts e.inspect
            puts e.backtrace.join("\n")
          end
        }.run
      end
    end

    def fetch
      TARGETS.map {|item|
        sleep 1
        res = RestClient.get(item[:url])
        doc = Nokogiri.parse(res)
        contents = doc.css('.pListBlock').select {|el|
          el.css('.pInfo li:nth-child(3)').text.include?('在庫あり')
        }.map do |el|
          {
            name: el.css('.pName').text,
            price: el.css('.pInfo li:first-child strong').text
          }
        end
        if contents.size > 0
          {
            title: item[:name],
            url: item[:url],
            contents: contents
          }
        end
      }.compact
    end

    def select_require_notify(list)
      list.select do |item|
        id = Digest::MD5.hexdigest(item.to_json)
        notified_at = @notify_cache[id] || Time.at(0)
        next if Time.now - notified_at < 60 * 10 # 10分以内は通知しない
        @notify_cache[id] = Time.now
        true
      end
    end

    def notify_channel(list)
      return if list.empty?

      word = %w(
        在庫ありそうだよ
        今なら買えるかもしれないねぇ
        んー、在庫状況変わった気がする
      ).sample

      robot.say(
        body: "@#{owner_name} #{word}",
        attachments: list.map {|item|
          {
            title: item[:title],
            title_link: item[:url],
            text: item[:contents].map {|content|
              "・#{content[:name]} (#{content[:price]})"
            }.join("\n")
          }
        },
        from: '',
        to: channel
      )
    end

    def owner_name
      ENV['NOTIFY_YODOBASHI_OWNER']
    end

    def channel
      ENV['NOTIFY_YODOBASHI_CHANNEL']
    end
  end
end
