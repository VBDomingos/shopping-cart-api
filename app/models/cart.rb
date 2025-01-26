class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  def update_total_price
    total = cart_items.joins(:product).sum('cart_items.quantity * products.price')
    update!(total_price: total)
  end

  def self.mark_abandoned_carts
    carts_to_abandon = Cart.where(abandoned_at: nil)
                           .where('updated_at < ?', 3.hours.ago)
    carts_to_abandon.update_all(abandoned_at: Time.current)
  end

  def self.remove_old_abandoned_carts
    carts_to_remove = Cart.where.not(abandoned_at: nil)
                          .where('abandoned_at < ?', 7.days.ago)
    carts_to_remove.destroy_all
  end
end
