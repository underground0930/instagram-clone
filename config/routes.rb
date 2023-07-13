# frozen_string_literal: true

Rails.application.routes.draw do
  get '/health_check', to: 'health_checks#show'
  root 'samples#index'

  get "/login", to: "user_sessions#new"
  post "/login", to: "user_sessions#create"
  delete "/logout", to: "user_sessions#destroy"

  resources :users, only: [:new, :create]

end
