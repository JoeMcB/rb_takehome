require_relative 'spec_helper.rb'

RSpec.describe PriceCalculator do
  let(:cart){
    # TODO: Use all carts as shared examples
    File.read("#{CLI_ROOT}/example/cart-4560.json")
  }

  let(:prices){
    File.read("#{CLI_ROOT}/example/base-prices.json")
  }

  it 'executes' do
    expect(PriceCalculator.execute(cart, prices)).to eq(true)
  end
end