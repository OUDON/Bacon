Rails.application.routes.draw do
  root 'contests#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :contestants, only: [:create]
  resources :users, only: [:index]
  resources :contests do
    resources :problems,    only: [:index, :create, :destroy]
    resource  :standing,    only: [:show]
    resources :submissions, only: [:index]
  end
end
