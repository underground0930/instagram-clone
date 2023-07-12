# frozen_string_literal: true

Rails.application.routes.draw do
  get '/health_check', to: 'health_checks#show'
  root 'samples#index'

  get "/login", to: "user_session#new"
  post "/login", to: "user_session#create"
  delete "/logout", to: "user_session#destroy"

  resources :signup, only: [:new, :create]

end
