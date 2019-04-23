Dir['./app/**/*.rb'].each{ |f| 
  puts "Including #{f}"
  require f 
}

puts "helper"