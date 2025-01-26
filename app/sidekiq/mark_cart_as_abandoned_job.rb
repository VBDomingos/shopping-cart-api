class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform(*args)
    Cart.mark_abandoned_carts
  end
end
