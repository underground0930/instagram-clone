# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  get '/health_check', to: 'health_checks#show'

  root 'posts#index'

  get "/login", to: "user_sessions#new"
  post "/login", to: "user_sessions#create"
  delete "/logout", to: "user_sessions#destroy"

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/mypage/account/edit", to: "users#edit"

  resources :posts do
    resources :comments, module: :posts, except: [:index]
    resource :like, module: :posts, only: [:create, :destroy]
  end

  resources :users, only: [:index, :show, :update] do
    resource :relationship, only: [:create, :destroy], module: :users
  end

  resources :notifications, only: [:index] do
    resource :read, only: %i[create], module: :notifications
  end

end
