require 'google/apis/calendar_v3'

module Calendars
  class Client
    def fetch(start_time, end_time)
      response = service.list_events('primary',
        single_events: true,
        order_by: 'startTime',
        time_min: start_time.iso8601,
        time_max: end_time.iso8601
      )
      response.items.map { |item| ::Calendars::Item.new(item) }
    end

    def register(schedule_item)
      # TODO
    end

    private

    def service
      @service ||= begin
        service = Google::Apis::CalendarV3::CalendarService.new
        service.client_options.application_name = 'leyak_bot'
        service.authorization = ::Models::GoogleIdentity::authorize(ENV['OWNER_UID'])
        service
      end
    end
  end
end
