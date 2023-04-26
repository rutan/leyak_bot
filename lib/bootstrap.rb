begin
  require 'dotenv'
  Dotenv.load
rescue => _
end
ENV['REPP_ENV'] ||= 'development'

require 'active_support'
require 'active_support/core_ext'
require 'zeitwerk'

require_relative './initializers/activerecord.rb'

require 'slack-ruby-client'
Slack::RealTime::Client.configure do |config|
  config.store_class = Slack::RealTime::Stores::Starter
end

require 'repp'

# auto loader
LIB_PATH = File.expand_path('..', __FILE__)
$:.unshift LIB_PATH

loader = Zeitwerk::Loader.new
loader.push_dir(LIB_PATH)
loader.setup
