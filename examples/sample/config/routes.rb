Rails.application.routes.draw do
  resources :pings, only: %i[index show]
end
