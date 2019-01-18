require 'erb'
require 'active_record'

begin
  path = File.expand_path('../../../db/config.yml', __FILE__)
  config = YAML::load(ERB.new(File.read(path)).result)
  env_conf = ENV.fetch('REPP_ENV', 'development')

  if defined?(DatabaseTasks)
    DatabaseTasks.env = env_conf
    DatabaseTasks.root = File.expand_path('../../..', __FILE__)
    DatabaseTasks.db_dir = File.expand_path('../../../db', __FILE__)
    DatabaseTasks.migrations_paths = File.expand_path('../../../db/migrate', __FILE__)
    DatabaseTasks.database_configuration = config
  end

  ActiveRecord::Base.establish_connection(config[env_conf])
  ActiveRecord::Base.time_zone_aware_attributes = true
end