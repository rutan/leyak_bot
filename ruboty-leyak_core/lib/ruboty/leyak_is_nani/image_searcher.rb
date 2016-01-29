require 'rest-client'
require 'json'

module Ruboty
  module LeyakIsNani
    class ImageSearcher
      def self.client
        @client ||= self.new
      end

      def initialize
        @searchers = []
        [:video, :live, :illust, :manga, :book, :channelarticle, :news].each do |service|
          @searchers << method(:search_by_nico).curry[service]
        end
        @searchers << method(:search_by_3d)
        @searchers << method(:search_by_niconare)
      end

      def search(word)
        @searchers.shuffle.lazy.map { |searcher|
          sleep 0.5
          searcher.call(word)
        }.find { |n| !!n }
      end

      private

      def search_by_nico(service, word)
        case service
        when :video
          gen_url = -> (n) { "http://www.nicovideo.jp/watch/#{n}" }
          targets = 'title,description,tags'
        when :live
          gen_url = -> (n) { "http://live.nicovideo.jp/watch/#{n}" }
          targets = 'title,description,tags'
        when :illust
          gen_url = -> (n) { "http://seiga.nicovideo.jp/seiga/#{n}" }
          targets = 'title,description,tags'
        when :manga
          gen_url = -> (n) { "http://seiga.nicovideo.jp/comic/#{n.gsub(/\D/, '')}" }
          targets = 'title,description,tags'
        when :book
          gen_url = -> (n) { "http://seiga.nicovideo.jp/watch/#{n}" }
          targets = 'title,description,tags'
        when :channelarticle
          gen_url = -> (n) { "http://ch.nicovideo.jp/article/#{n}" }
          targets = 'title,description'
        when :news
          gen_url = -> (n) { "http://news.nicovideo.jp/watch/#{n}" }
          targets = 'title,caption,tags'
        else
          raise 'unknown service'
        end
        response = JSON.parse RestClient.get(
          "http://api.search.nicovideo.jp/api/v2/#{service}/contents/search",
          params: {
            q: word,
            targets: targets,
            fields: 'contentId',
            _sort: '-viewCounter',
            _limit: 10,
            _context: USER_AGENT
          },
          user_agent: USER_AGENT
        )
        result = response['data'].sample
        gen_url.call(result['contentId']) if result
      rescue => e
        puts "#{e.inspect} #{e.backtrace}"
        nil
      end

      def search_by_3d(word)
        response = JSON.parse RestClient.get(
          'http://3d.nicovideo.jp/search.json',
          params: {
            word: word,
            word_type: 'keyword',
            sort: 'total',
          },
          user_agent: USER_AGENT
        )
        result = response['works'].sample
        "http://3d.nicovideo.jp/works/td#{result['id']}" if result
      rescue => e
        puts "#{e.inspect} #{e.backtrace}"
        nil
      end

      def search_by_niconare(word)
        response = JSON.parse RestClient.get(
          "https://niconare.nicovideo.jp/api/v1/search/#{URI.encode word}",
          user_agent: USER_AGENT
        )
        result = response['data'].sample
        "http://niconare.nicovideo.jp/watch/kn#{result['id']}" if result
      rescue => e
        puts "#{e.inspect} #{e.backtrace}"
        nil
      end

      USER_AGENT = 'ru_shalm'
    end
  end
end

