require 'rails_helper'

RSpec.describe "/cart", type: :request do
  let(:product) { Product.create!(name: "Test Product", price: 10.0) }

  before do
    get '/cart' #!! Cria o carrinho pelo GET, replicando o processo real
    @cart = Cart.find(JSON.parse(response.body)['id'])
  end

  describe "POST /add_item" do
    context 'quando o produto já está no carrinho' do
      before do
        post '/cart/add_item', params: { product_id: product.id, quantity: 1 }
      end

      it 'atualiza a quantidade do item existente' do
        expect {
          post '/cart/add_item', params: { product_id: product.id, quantity: 1 }
        }.to change { @cart.reload.cart_items.first.quantity }.from(1).to(2)
      end
    end

    context 'com quantidade inválida' do
      it 'retorna erro' do
        post '/cart/add_item', params: { product_id: product.id, quantity: -5 }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include("Quantity must be greater than 0")
      end
    end

    context 'quando o produto não está no carrinho' do
      it 'adiciona um novo item' do
        expect {
          post '/cart/add_item', params: { product_id: product.id, quantity: 1 }
        }.to change { @cart.reload.cart_items.count }.from(0).to(1)
      end
    end
  end

  describe "GET /cart" do
    context 'com itens no carrinho' do
      before do
        post '/cart/add_item', params: { product_id: product.id, quantity: 2 }
      end

      it 'retorna o carrinho com itens' do
        get '/cart'
        expect(response).to have_http_status(:ok)
        expect(json_response['id']).to eq(@cart.id)
        expect(json_response['products'].first['quantity']).to eq(2)
      end
    end
  end

  describe "DELETE /cart/:product_id" do
    context 'com product_id inválido' do
      it 'retorna 404' do
        delete '/cart/invalid_id'
        expect(response).to have_http_status(:not_found)
        expect(json_response['error']).to eq('Product not found')
      end
    end

    context 'com product_id válido' do
      before do
        post '/cart/add_item', params: { product_id: product.id, quantity: 1 }
      end

      it 'remove o item do carrinho' do
        expect {
          delete "/cart/#{product.id}"
        }.to change { @cart.reload.cart_items.count }.from(1).to(0)
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end