require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'when validating' do
    it 'validates numericality of total_price' do
      cart = described_class.new(total_price: -1)
      expect(cart.valid?).to be_falsey
      expect(cart.errors[:total_price]).to include("must be greater than or equal to 0")
    end
  end

  describe '.mark_abandoned_carts' do
    let!(:active_cart) do
      Cart.create!(total_price: 0, updated_at: 2.hours.ago)
    end
    
    let!(:abandoned_cart) do
      Cart.create!(total_price: 0, updated_at: 4.hours.ago)
    end

    it 'marks carts as abandoned after 3 hours of inactivity' do
      described_class.mark_abandoned_carts
      expect(abandoned_cart.reload.abandoned_at).not_to be_nil
      expect(active_cart.reload.abandoned_at).to be_nil
    end
  end

  describe '.remove_old_abandoned_carts' do
    let!(:recent_abandoned) do
      Cart.create!(total_price: 0, abandoned_at: 6.days.ago)
    end
    
    let!(:old_abandoned) do
      Cart.create!(total_price: 0, abandoned_at: 8.days.ago)
    end

    it 'removes carts abandoned for more than 7 days' do
      expect {
        described_class.remove_old_abandoned_carts
      }.to change(Cart, :count).by(-1)
      
      expect(Cart.exists?(old_abandoned.id)).to be false
      expect(Cart.exists?(recent_abandoned.id)).to be true
    end
  end
end