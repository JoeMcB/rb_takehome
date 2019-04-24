class CartLineItem
  # Example Hash
  # {
  #   "product-type": "hoodie",
  #   "options": {
  #     "size": "small",
  #     "colour": "white",
  #     "print-location": "front"
  #   },
  #   "artist-markup": 20,
  #   "quantity": 1
  #}

  ##
  # Represent an item in a cart.

  attr_reader :product_type, :artist_markup, :quantity, :options, :unit_price
  def initialize(product_type, artist_markup, quantity, unit_price, options = {})
    @product_type = product_type
    @artist_markup = artist_markup
    @quantity = quantity
    @options = options
    @unit_price = unit_price
  end

  def total
    (@unit_price + (@unit_price * artist_markup_pct).round) * @quantity
  end

  private

  def artist_markup_pct
    @artist_markup.to_f / 100.0
  end
end
