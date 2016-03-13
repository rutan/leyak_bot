require 'active_support'
require 'active_support/core_ext'
require 'ruboty/leyak_core/version'

require 'ruboty/leyak_garoon/handler' if ENV['IGNORE_GAROON'].to_i == 0
require 'ruboty/leyak_todo/handler'
require 'ruboty/leyak_is_nani/handler'

require 'ruboty/leyak_core/handler'
