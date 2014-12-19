Rails.application.routes.draw do
  devise_for :users

  match '', to: 'home#show', via: [:get, :post, :put, :patch, :delete], constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }
  resources :issues, defaults: {format: :json}, only: [:index]
  root 'home#index'
end
