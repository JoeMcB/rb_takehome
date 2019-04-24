#!/usr/bin/env ruby

require_relative '../config/boot.rb'

begin
  cart_json = File.read(ARGV[0])
  price_json = File.read(ARGV[1])

  PriceCalculator.execute(cart_json, price_json)
rescue StandardError => e
  puts e.message
  puts "Correct Use:  ruby bin/price_calc.rb PATH/TO/CART.json PATH/TO/PRICES.json"
end