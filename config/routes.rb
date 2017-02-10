Rails.application.routes.draw do
  devise_for :users
  resources :contests

  post 'contests/:id/add_problem', to: 'contests#add_problem', as: :add_problem
end
