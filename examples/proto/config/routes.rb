# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :pings, only: %i[index show] do
    get :show_params, on: :collection
  end

  resources :users, only: %i[index show new create]

  get '/login', to: 'sessions#index'
  post '/login', to: 'sessions#login'
  post '/logout', to: 'sessions#logout'

  get '/mypage', to: 'mypage#index'
end
