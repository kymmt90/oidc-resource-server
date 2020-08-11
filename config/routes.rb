Rails.application.routes.draw do
  use_doorkeeper_openid_connect
  use_doorkeeper
  root 'sessions#new'

  resources :items, defaults: { format: :json }, only: [:index, :show, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
end
