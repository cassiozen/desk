Rails.application.routes.draw do
  devise_for :users

  match '', to: 'home#show', via: [:get, :post, :put, :patch, :delete], constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }
  resource :dashboard
  resources :issues, path: :requests do
    resources :interactions
  end

  resources :images, defaults: {format: :json}, only: [:create]
  resources :attachments, defaults: {format: :json}, only: [:create]

  root 'home#index'
end
