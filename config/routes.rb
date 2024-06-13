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

  # Define root path
  root to: 'homes#index'
end
