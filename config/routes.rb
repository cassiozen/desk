Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  #match '', to: 'home#show', via: [:get, :post], constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }


end
