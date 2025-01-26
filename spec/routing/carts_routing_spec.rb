require "rails_helper"

RSpec.describe CartsController, type: :routing do
  describe 'roteamento básico' do
    it 'GET /cart -> carts#show' do
      expect(get: '/cart').to route_to('carts#show')
    end

    it 'POST /cart/add_item -> carts#add_item' do
      expect(post: '/cart/add_item').to route_to('carts#add_item')
    end

    it 'DELETE /cart/:product_id -> carts#destroy' do
      expect(delete: '/cart/1').to route_to(
        controller: 'carts',
        action: 'destroy',
        product_id: '1'
      )
    end
  end

  describe 'restrições de roteamento' do 
    it 'não aceita métodos não suportados' do #!! Como explicado no routes.rb
      expect(patch: '/cart/1').not_to be_routable
      expect(put: '/cart/1').not_to be_routable
    end
  end
end