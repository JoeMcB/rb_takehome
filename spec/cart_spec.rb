require_relative 'spec_helper.rb'

RSpec.describe Cart do
  describe '#load' do
    it 'loads a good cart' do
      pending("need to write output")
    end

    it 'raises an exception on a bad cart' do
      expect(Cart.load(trash_json)).to_raise JSON::Schema::ValidationError
    end
  end
end