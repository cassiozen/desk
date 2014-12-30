Rails.application.routes.draw do
  devise_for :users

  match '', to: 'home#show', via: [:get, :post, :put, :patch, :delete], constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }
  resource :dashboard
  resources :issues, only: [:index], path: :requests

  root 'home#index'
end
