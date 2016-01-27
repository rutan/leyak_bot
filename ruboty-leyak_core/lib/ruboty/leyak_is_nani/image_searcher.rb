require 'rest-client'
require 'json'

module Ruboty
  module LeyakIsNani
    class ImageSearcher
      def search(word)
        [:video, :illust, :manga, :book].shuffle.lazy.map { |service|
          sleep 1
          search_by_nico(service, word)
        }.find { |n| !!n }
      end

      private

      def search_by_nico(service, word)
        gen_url =
          case service
          when :video
            -> (n) { "http://www.nicovideo.jp/watch/#{n}" }
          when :illust
            -> (n) { "http://seiga.nicovideo.jp/seiga/#{n}" }
          when :manga
            -> (n) { "http://seiga.nicovideo.jp/comic/#{n.gsub(/\D/, '')}" }
          when :book
            -> (n) { "http://seiga.nicovideo.jp/watch/#{n}" }
          else
            raise 'unknown service'
          end
        response = JSON.parse RestClient.get(
          "http://api.search.nicovideo.jp/api/v2/#{service}/contents/search",
          params: {
            q: word,
            targets: 'title,description,tags',
            fields: 'contentId',
            _sort: '-viewCounter',
            _limit: 10,
            _context: 'ru_shalm'
          },
          user_agent: 'ru_shalm'
        )
        result = response['data'].sample
        gen_url.call(result['contentId']) if result
      rescue => e
        puts "#{e.inspect} #{e.backtrace}"
        nil
      end
    end
  end
end

