LIB_PATH = File.expand_path('../', __FILE__)
$LOAD_PATH.unshift LIB_PATH

# common gem
require 'active_support'
require 'active_support/core_ext'

# utils
require 'utils/notify_action'
require 'utils/remind_timer'

# entity
require 'entities/base'
require 'entities/schedule_item'

# repository
require 'repositories/schedule_repository'

# action
require 'actions/schedules/show'
require 'actions/schedules/register'

# handler
Dir.glob("#{LIB_PATH}/handlers/*.rb").sort.each do |path|
  require path
end