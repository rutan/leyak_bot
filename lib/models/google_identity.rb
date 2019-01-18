require 'googleauth'
require 'googleauth/token_store'
require 'google/apis/calendar_v3'

module Models
  class GoogleIdentity < ApplicationRecord
    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
    SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR

    class NoAuthorized < StandardError; end

    class << self
      def authorize(uid)
        token_store = ::Calendars::TokenStore.new
        client_token = Google::Auth::ClientId.new(ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'])
        authorizer = Google::Auth::UserAuthorizer.new(client_token, SCOPE, token_store)
        credentials = authorizer.get_credentials(uid)
        raise NoAuthorized if credentials.nil?
        credentials
      end

      def authorize_or_register(uid)
        token_store = ::Calendars::TokenStore.new
        client_token = Google::Auth::ClientId.new(ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'])
        authorizer = Google::Auth::UserAuthorizer.new(client_token, SCOPE, token_store)
        credentials = authorizer.get_credentials(uid)
        if credentials.nil?
          url = authorizer.get_authorization_url(base_url: OOB_URI)
          STDOUT.puts "#{url}"
          code = STDIN.gets.strip
          credentials = authorizer.get_and_store_credentials_from_code(
            user_id: uid, code: code, base_url: OOB_URI
          )
        end
        credentials
      end
    end
  end
end