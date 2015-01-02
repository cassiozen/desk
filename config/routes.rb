Rails.application.routes.draw do
  devise_for :users

  match '', to: 'home#show', via: [:get, :post, :put, :patch, :delete], constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }
  resource :dashboard
  resources :issues, path: :requests do
    resources :interactions
  end

  root 'home#index'
end
