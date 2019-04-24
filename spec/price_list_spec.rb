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

    let(:flat_item_hash){
      JSON.parse('{
        "product-type": "sticker",
        "options": {
          "size": ["xl"]
        },
        "base-price": 3848
      }')
    }

    let(:simple_item_hash){
      JSON.parse('{
        "product-type": "hoodie",
        "options": {
        },
        "base-price": 3848
      }')
    }

    let(:complex_item_hash){
      JSON.parse('{
        "product-type": "hoodie",
        "options": {
          "size": ["small", "medium", "large"],
          "colour": ["white", "blue"]
        },
        "base-price": 3848
      }')
    }

    let(:complex_item_hash_extended){
      JSON.parse('{
        "product-type": "hoodie",
        "options": {
          "size": ["xl", "2xl"],
          "colour": ["white", "blue"]
        },
        "base-price": 4130
      }')
    }

    describe '#add_item' do
      it 'adds a flat item' do
        # flat item = no options
        price_list.add_item(flat_item_hash)
      end

      it 'adds a simple item' do
        # simple = 1 option
        price_list.add_item(simple_item_hash)
      end

      it 'successfully adds an complex item' do
        # complex = recursive
        price_list.add_item(complex_item_hash)

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

      it 'successfully adds multiple complex item' do
        # complex = recursive
        price_list.add_item(complex_item_hash)
        price_list.add_item(complex_item_hash_extended)

        expected_hash = {
          'hoodie' => {
            'white' => {
              'small' => 3848,
              'medium' => 3848,
              'large' => 3848,
              "xl" => 4130,
              "2xl" => 4130
            },
            'blue' => {
              'small' => 3848,
              'medium' => 3848,
              'large' => 3848,
              "xl" => 4130,
              "2xl" => 4130
            }
          }
        }
        expect(price_list.product_hash).to eq(expected_hash)
      end
    end

    describe '#get_price' do
      it 'looks up complex item price' do
        price_list.add_item(complex_item_hash)
        expect(price_list.get_price('hoodie', 'colour' => 'white', 'size' => 'small')).to eq(3848)
        expect(price_list.get_price('hoodie', 'colour' => 'blue', 'size' => 'small')).to eq(3848)
        expect(price_list.get_price('hoodie', 'colour' => 'white', 'size' => 'large')).to eq(3848)
      end

      it 'looks up multiple complex item prices' do
        price_list.add_item(complex_item_hash)
        price_list.add_item(complex_item_hash_extended)
        expect(price_list.get_price('hoodie', 'colour' => 'white', 'size' => 'small')).to eq(3848)
        expect(price_list.get_price('hoodie', 'colour' => 'blue', 'size' => 'small')).to eq(3848)
        expect(price_list.get_price('hoodie', 'colour' => 'white', 'size' => '2xl')).to eq(4130)
      end
    end
  end
end
