$LOAD_PATH.unshift File.expand_path('../', __FILE__)

# common gem
require 'active_support'
require 'active_support/core_ext'

# leyak
require 'ruboty/leyak_garoon/handler' if ENV['IGNORE_GAROON'].to_i == 0
require 'ruboty/leyak_todo/handler'
require 'ruboty/leyak_core/handler'
