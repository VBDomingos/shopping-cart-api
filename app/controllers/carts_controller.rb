class CartsController < ApplicationController
  before_action :current_cart, only: %i[show add_item destroy]
  before_action :set_product, only: %i[add_item destroy]

  # GET /cart
  def show
    render json: serialize_cart(@current_cart)
  end

  # POST /cart/add_item
  def add_item
    cart_item = @current_cart.cart_items.find_or_initialize_by(product: @product)
    
    if cart_item.persisted?
      cart_item.quantity += cart_item_params[:quantity].to_i
    else
      cart_item.quantity = cart_item_params[:quantity].to_i
    end

    if cart_item.save
      @current_cart.update_total_price
      @current_cart.reload
      render json: serialize_cart(@current_cart)
    else
      render json: { errors: cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /cart/:product_id
  def destroy
    cart_item = @current_cart.cart_items.find_by(product: @product)
    
    if cart_item&.destroy
      @current_cart.update_total_price
      @current_cart.reload
      render json: serialize_cart(@current_cart)
    else
      render json: { error: 'Product not in cart' }, status: :not_found
    end
  end

  private

  def current_cart
    @current_cart ||= begin
      if session[:cart_id]
        Cart.includes(cart_items: :product).find_by(id: session[:cart_id]) || create_new_cart
      else
        create_new_cart
      end
    end
  end

  def set_product
    @product = Product.find(params[:product_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Product not found' }, status: :not_found
  end

  def create_new_cart
    cart = Cart.create!(total_price: 0)
    session[:cart_id] = cart.id
    cart
  end

  def cart_item_params
    params.permit(:product_id, :quantity)
  end

  def serialize_cart(cart)
    {
      id: cart.id,
      products: cart.cart_items.includes(:product).map do |item|
        {
          id: item.product.id,
          name: item.product.name,
          quantity: item.quantity,
          unit_price: item.product.price.to_f,
          total_price: (item.quantity * item.product.price).to_f
        }
      end,
      total_price: cart.total_price.to_f
    }
  end
end