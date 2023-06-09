Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users, only: [:create]
  post '/login', to: 'sessions#create'

  root 'sessions#create'
end
