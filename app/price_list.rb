class PriceList
  BASE_PRICES_SCHEMA = File.read("#{LIB_ROOT}/base-prices.schema.json")

  def self.load(json)
    JSON::Validator.validate!(BASE_PRICES_SCHEMA, json)
  end
end
