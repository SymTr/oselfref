Rails.application.routes.draw do
  get 'homes/index'
  
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  resources :posts, only: [:index, :new, :create] do
    collection do
      get :index, defaults: { format: 'html' }
      get :index, defaults: { format: 'csv' }
    end
  end

  resources :passkeys, only: [:new, :create, :index, :destroy] do
    post 'callback', on: :collection
  end

  post 'users/passkey_authenticate', to: 'users/sessions#passkey_authenticate'

  # Define root path
  root to: 'homes#index'
end