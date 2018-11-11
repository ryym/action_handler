# frozen_string_literal: true

Rails.application.routes.draw do
  resources :pings, only: %i[index show]

  resources :users, only: %i[index show new create]

  get '/login', to: 'sessions#index'
  post '/login', to: 'sessions#login'
  post '/logout', to: 'sessions#logout'

  get '/mypage', to: 'mypage#index'
end
