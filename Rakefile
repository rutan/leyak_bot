require 'bundler/setup'
require 'active_record'

include ActiveRecord::Tasks

task :environment do
  require_relative './lib/bootstrap.rb'
end

load 'active_record/railties/databases.rake'
namespace :db do
  task :load_config do
    require_relative './lib/bootstrap.rb'
  end
end

Dir.glob(File.expand_path('../lib/tasks/*.rake', __FILE__)).each do |path|
  load(path)
end
