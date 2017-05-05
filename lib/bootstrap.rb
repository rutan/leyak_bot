LIB_PATH = File.expand_path('../', __FILE__)
$LOAD_PATH.unshift LIB_PATH

# common gem
require 'active_support'
require 'active_support/core_ext'

# leyak
require 'ruboty/leyak_garoon/handler' if ENV['IGNORE_GAROON'].to_i == 0

Dir.glob("#{LIB_PATH}/handlers/*.rb").sort.each do |path|
  require path
end