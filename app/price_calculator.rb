
module PriceCalculator
  def self.execute(cart_json, price_json)
    price_list = PriceList.load(price_json)
    cart = Cart.load(cart_json, price_list)

    puts cart.total
  end
end