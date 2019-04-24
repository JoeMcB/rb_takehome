require_relative 'spec_helper.rb'

RSpec.describe CartLineItem do
  let(:cart_line_item){
    CartLineItem.new('hoodie', 20, 2, 1700, {'colour' => 'white', 'size' => 'medium'})
  }

  describe 'instance' do
    it '#markup_pct' do
      expect(cart_line_item.send(:artist_markup_pct)).to eq(0.2)
    end

    it '#total' do
      expect(cart_line_item.total).to eq(4080)
    end
  end
end