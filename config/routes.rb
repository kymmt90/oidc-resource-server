Rails.application.routes.draw do
  resources :items, defaults: { format: :json }, only: [:index, :show, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
end
