
module PriceCalculator
  def self.execute(cart_json, price_json)
    Cart.load(cart_json)
    PriceList.load(price_json)

    true
  end
end