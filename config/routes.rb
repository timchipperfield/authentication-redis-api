Rails.application.routes.draw do
  resources :logins, only: :create
  resources :authorizations, only: :create
end
