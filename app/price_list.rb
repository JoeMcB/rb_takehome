class PriceList
  BASE_PRICES_SCHEMA = File.read("#{LIB_ROOT}/base-prices.schema.json")

  attr_accessor :heirarchy
  attr_reader :product_hash

  def self.load(json)
    JSON::Validator.validate!(BASE_PRICES_SCHEMA, json)
    raw_hash = JSON.parse(json)

    price_list = PriceList.new
    price_list.heirarchy = extract_option_heirarchy(raw_hash)
    raw_hash.each do |item|
      price_list.add_item(item)
    end

    price_list
  end

  # Standardize order we'll store and lookup up.
  def self.extract_option_heirarchy(raw_hash)
    raw_hash.collect { |price_item|
      price_item['options'].keys
    }.flatten.uniq.sort
  end

  def initialize
    @product_hash = {}
  end

  def get_price(product_type, options_hash = {})
    current_hash = product_hash[product_type]

    if options_hash.empty?
      price = current_hash[:default]
    else
      heirarchy.each do |heirarchy_option_name|
        lookup_option = options_hash[heirarchy_option_name]
        next if lookup_option.nil?

        current_hash = current_hash[lookup_option]
      end
      price = current_hash
    end

    raise 'Item Not Found!' if price.nil?
    price
  end

  ##
  # Load an item as defined by the schema:
  # {
  #   "product-type": "hoodie",
  #   "options": {
  #     "colour": ["white", "dark"],
  #     "size": ["small", "medium"]
  #   },
  #   "base-price": 3800
  # },
  def add_item(item)
    @product_hash[item['product-type']] ||= {}
    options = item['options']
    price = item['base-price']
    generated_hash = recursive_add_item(@heirarchy.dup, options, price)

    # Set a default price in case there are no options 
    generated_hash = { default: generated_hash } unless generated_hash.is_a? Hash

    # Combine hashes via deep_merge
    @product_hash[item['product-type']].deep_merge!(generated_hash)
  end

  def recursive_add_item(disposable_heirarchy, options, price, count = 1)
    log("\t"*count + "In #{disposable_heirarchy.inspect}")
    # Base case!
    return price if disposable_heirarchy.empty?

    # Iterate heirarchy until find option name for this item
    option_name = true
    until  (!options[option_name].nil? || disposable_heirarchy.empty?)
      option_name = disposable_heirarchy.shift
    end

    # Return price if we've hit bottom of heirarchy without price.
    # Turns out supporting dynamic option ordering complicates this!
    return price if options[option_name].nil? 

    return_hash = {}
    options[option_name].each do |option_value|
      children = recursive_add_item(disposable_heirarchy.dup, options, price, count+1)
      return_hash[option_value] = children
      log("\t"*count + "Assign #{option_value} = #{children}")
    end
    return_hash
  end
end
