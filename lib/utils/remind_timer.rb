module Utils
  class RemindTimer
    def initialize(remind_sec, messages = [])
      @remind_sec = remind_sec
      @messages = messages
      @last_remind_at = Time.now
    end

    def touch
      @last_remind_at = Time.now + remind_sec
    end

    attr_reader :remind_sec, :last_remind_at, :messages
  end
end
