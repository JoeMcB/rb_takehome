require_relative '../config/boot.rb'

Dir['./app/**/*.rb'].each{ |f| 
  log("Including #{f}")
  require f 
}