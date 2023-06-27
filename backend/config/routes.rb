Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  post '/login', to: 'sessions#create'
  post '/register', to: 'registrations#create'

  namespace :manager do
    resources :dashboards, only: [:index]
    resources :point_presences, only: [:index]
    resources :users, only: [:index, :create, :update, :destroy]

    get '/info', to: 'user#index'
  end

  namespace :collaborator do
    resources :dashboards, only: [:index]
    resources :point_presences, only: [:index, :create]
    resources :users, only: [:index]
  end

  resources :users, only: [:update]

  root 'sessions#create'
end
