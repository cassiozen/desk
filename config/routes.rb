Rails.application.routes.draw do
  devise_for :users

  match '', to: 'home#show', via: [:get, :post], constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }
  root 'home#index'

end
