class RemoveAbandonedCartsJob
  include Sidekiq::Job

  def perform
    Cart.remove_old_abandoned_carts
  end
end