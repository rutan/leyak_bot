require 'ragoon'
require 'date'

module Utils
  def self.notify_action(robot, message: nil, attachments: nil)
    owner_name = "@#{ENV['NOTIFY_OWNER']}"
    channel = "#{ENV['NOTIFY_CHANNEL']}"
    robot.say(
      body: "#{owner_name} #{message}",
      attachments: attachments || [],
      from: '',
      to: channel
    )
  end
end
