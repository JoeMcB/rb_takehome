class Cart
  CART_SCHEMA = File.read("#{LIB_ROOT}/cart.schema.json")

  def self.load(json, price_list)
    JSON::Validator.validate!(CART_SCHEMA, json)
    # {
    #   "product-type": "hoodie",
    #   "options": {
    #     "size": "small",
    #     "colour": "white",
    #     "print-location": "front"
    #   },
    #   "artist-markup": 20,
    #   "quantity": 1
    # }
    raw_hash = JSON.parse(json)
    items = []

    raw_hash.each do |item|
      log(item)
      log(price_list.get_price(item['product-type'], item['options']))
      items << CartLineItem.new(
        item['product-type'],
        item['artist-markup'],
        item['quantity'],
        price_list.get_price(item['product-type'], item['options']),
        item['options']
      )
    end

    Cart.new(items)
  end

  def initialize(items)
    @items = items
  end

  def total
    @items.sum(&:total)
  end
end
