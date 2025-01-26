require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products
  get "up" => "rails/health#show", as: :rails_health_check

  #!! Rotas para o carrinho. Não foi usado resources :carts por não ser RESTful
  #!! Foram feitas 3 rotas pois o doc estava se contradizendo quanto ao número de rotas
  #!! No final do doc, estava escrito seria necessário necessário a construção de 4 rotas,
  #!! porém, no começo informava 3 rotas e uma das rotas é "inutil", já que o post para cart
  #!! e o post para cart/add_item teria a mesma funcionalidade prática. Então acabei por utilizando
  #!! apenas a rota cart/add_item
  get    'cart',            to: 'carts#show'
  post   'cart/add_item',   to: 'carts#add_item'
  delete 'cart/:product_id', to: 'carts#destroy'

  root "rails/health#show"
end
