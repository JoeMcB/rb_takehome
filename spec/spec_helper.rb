require_relative '../config/boot.rb'

Dir['./app/**/*.rb'].each{ |f| 
  puts "Including #{f}"
  require f 
}