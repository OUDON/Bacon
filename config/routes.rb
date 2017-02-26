Rails.application.routes.draw do
  root 'contests#index'
  devise_for :users
  resources :contestants, only: [:create]
  resources :contests do
    resources :problems, only: [:create, :destroy]
  end

  # post 'contests/:id/add_problem', to: 'contests#add_problem', as: :add_problem
end
