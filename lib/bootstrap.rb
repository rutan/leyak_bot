# common gem
require 'active_support'
require 'active_support/core_ext'
require 'active_support/dependencies'

# config
LIB_PATH = File.expand_path('../', __FILE__)
$LOAD_PATH.unshift LIB_PATH
ActiveSupport::Dependencies.autoload_paths << LIB_PATH

# utils
require_relative './utils/notify_action.rb'

# entities / handlers
%w[entities handlers].each do |dir|
  Dir.glob("#{LIB_PATH}/#{dir}/**/*.rb").sort.each { |path| require(path) }
end

