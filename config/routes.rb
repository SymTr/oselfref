Rails.application.routes.draw do
  devise_for :users

  resources :posts, only: [:index, :new, :create]

  # Define root path
  root to: 'posts#index'
end
