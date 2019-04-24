require_relative 'spec_helper.rb'

RSpec.describe PriceList do
  let(:base_prices_json){
    File.read("#{CLI_ROOT}/example/base-prices.json")
  }

  let(:base_prices_parsed){
    JSON.parse(base_prices_json)
  }

  describe "class methods" do
    describe '#load' do
      it 'loads a good price list' do
        price_list = PriceList.load(base_prices_json)
        puts price_list.product_hash.inspect
      end

      it 'raises an exception on a bad cart' do
        expect {
          PriceList.load('{ trash_json: true }')
        }.to raise_error(JSON::Schema::ValidationError)
      end
    end

    describe '#extract_option_heirarchy' do
      it 'pulls a heirarchy from a valid price list' do
        heirarchy = PriceList.extract_option_heirarchy(base_prices_parsed)

        expect(heirarchy).to eq(['colour', 'size'])
      end
    end
  end

  describe "instance methods" do
    let(:price_list){
      pl = PriceList.new
      pl.heirarchy = ['colour', 'size']
      pl
    }

    describe '#add_item' do
      it 'adds a flat item' do
        # flat item = no options
        item_hash = JSON.parse('{
          "product-type": "sticker",
          "options": {
            "size": ["xl"]
          },
          "base-price": 3848
        }')
        price_list.add_item(item_hash)
      end

      it 'adds a simple item' do
        # simple = 1 option
        item_hash = JSON.parse('{
          "product-type": "hoodie",
          "options": {
          },
          "base-price": 3848
        }')
        price_list.add_item(item_hash)
      end

      it 'successfully adds an complex item' do
        # complex = recursive

        item_hash = JSON.parse('{
          "product-type": "hoodie",
          "options": {
            "size": ["small", "medium", "large"],
            "colour": ["white", "blue"]
          },
          "base-price": 3848
        }')
        price_list.add_item(item_hash)

        expected_hash = {
          'hoodie' => {
            'white' => {
              'small' => 3848,
              'medium' => 3848,
              'large' => 3848
            },
            'blue' => {
              'small' => 3848,
              'medium' => 3848,
              'large' => 3848
            }
          }
        }
        expect(price_list.product_hash).to eq(expected_hash)
      end
    end
  end
end
