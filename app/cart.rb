class Cart
  CART_SCHEMA = File.read("#{LIB_ROOT}/cart.schema.json")

  def self.load(json)
    JSON::Validator.validate!(CART_SCHEMA, json)
  end
end
