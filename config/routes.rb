Rails.application.routes.draw do
  root 'contests#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :contestants, only: [:create]
  resources :contests do
    resources :problems, only: [:create, :destroy]
  end
end
