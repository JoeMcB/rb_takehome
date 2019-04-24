# Initial setup used for CLI and RSpec

CONFIG_ROOT = File.dirname(__FILE__)
CLI_ROOT = File.join(CONFIG_ROOT, '../')
APP_ROOT = File.join(CLI_ROOT, 'app/')
LIB_ROOT = File.join(CLI_ROOT, 'lib/')

DEBUG = false

require 'bundler/setup'
Bundler.require

def log(msg)
  puts msg if DEBUG
end

Dir["#{APP_ROOT}/**/*.rb"].each{ |f| 
  log("Including #{f}")
  require f
}
