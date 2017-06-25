require 'ragoon'
require 'date'

module Repositories
  class ScheduleRepository
    def initialize(brain)
      @brain = brain
    end
    attr_reader :brain

    def fetch(start_time, end_time)
      Ragoon::Services::Schedule.new.schedule_get_events(
        start: start_time.utc,
        end: end_time.utc
      ).map { |e| ::Entities::ScheduleItem.from(e) }
    end

    def register(schedule_item)
      e = Ragoon::Services::Schedule.new.schedule_add_event(
        title: schedule_item.title,
        description: 'from @leyak_bot',
        start_at: schedule_item.start_at,
        end_at: schedule_item.end_at,
        users: schedule_item.users.map {|u| u[:id]},
        allday: schedule_item.allday?
      )
      ::Entities::ScheduleItem.from(e)
    end
  end
end
