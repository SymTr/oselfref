Rails.application.routes.draw do
  get 'homes/index'
  
  devise_for :users

  resources :posts, only: [:index, :new, :create]

  # Define root path
  root to: 'homes#index'
end
