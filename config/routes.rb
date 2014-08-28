Rails.application.routes.draw do
  
  get "users/new"

  resources :contracts
  resources :markets
  resources :users

  root to: 'static_pages#home'

  match '/signup', to: 'users#new',    via: 'get'
  match '/home',    to: 'static_pages#home',    via: 'get'
  match '/how_works',   to: 'static_pages#how_works',   via: 'get'
  match '/trader_manual', to: 'static_pages#trader_manual', via: 'get'
  match '/faq',    to: 'static_pages#faq',    via: 'get'
  match '/contact',    to: 'static_pages#contact',    via: 'get'
  match '/about',    to: 'static_pages#about',    via: 'get'

end
