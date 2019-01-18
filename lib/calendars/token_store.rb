require 'googleauth'
require 'googleauth/token_store'

module Calendars
  class TokenStore < Google::Auth::TokenStore
    def load(id)
      identity = ::Models::GoogleIdentity.find_by!(uid: id)
      {
        client_id: ENV['GOOGLE_CLIENT_ID'],
        scope: JSON.parse(identity.scope),
        access_token: identity.access_token,
        refresh_token: identity.refresh_token,
        expiration_time_millis: identity.expiration_time_millis
      }.to_json
    rescue ActiveRecord::RecordNotFound
      nil
    end

    def store(id, token)
      obj = JSON.parse(token)
      ActiveRecord::Base.transaction do
        identity = ::Models::GoogleIdentity.find_or_initialize_by(uid: id)
        identity.update!(
          access_token: obj['access_token'],
          refresh_token: obj['refresh_token'],
          scope: obj['scope'].to_json,
          expiration_time_millis: obj['expiration_time_millis']
        )
      end
    end

    def delete(id)
      ::Models::GoogleIdentity.find_by!(uid: id).destroy!
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end
end
