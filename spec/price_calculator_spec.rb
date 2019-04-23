require_relative 'spec_helper.rb'

RSpec.describe PriceCalculator do
  it 'executes' do
    expect(PriceCalculator.execute).to eq(false)
  end
end