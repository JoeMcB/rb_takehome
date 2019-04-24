require_relative 'spec_helper.rb'

RSpec.describe Cart do
  let(:simple_cart_json){
    File.read("#{CLI_ROOT}/example/cart-4560.json")
  }

  let(:complex_cart_json){
    File.read("#{CLI_ROOT}/example/cart-9363.json")
  }

  let(:price_list){
    PriceList.load(File.read("#{CLI_ROOT}/example/base-prices.json"))
  }

  describe '#load' do
    it 'loads a simple cart' do
      Cart.load(simple_cart_json, price_list)
    end

    it 'loads a complex cart' do
      Cart.load(complex_cart_json, price_list)
    end

    it 'raises an exception on a bad cart' do
      expect{
        Cart.load('{ trash_json: true }', price_list)
      }.to raise_error(JSON::Schema::ValidationError)
    end
  end

  describe 'instance' do
    describe '#total' do
      it 'single item' do
        expect(Cart.load(simple_cart_json, price_list).total).to eq(4560)
      end

      it 'multiple items' do
        expect(Cart.load(complex_cart_json, price_list).total).to eq(9363)
      end
    end
  end
end