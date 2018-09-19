require 'active_support'
require 'active_support/core_ext'
require 'active_support/dependencies'
require 'mobb/base'
require_relative './monkey.rb'

# auto loader
LIB_PATH = File.expand_path('..', __FILE__)
$:.unshift LIB_PATH
ActiveSupport::Dependencies.autoload_paths << LIB_PATH

require_relative './application.rb'
