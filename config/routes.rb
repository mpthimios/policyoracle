Rails.application.routes.draw do

 
  resources :markets do
    resources :contracts, shallow: true
  end

  resources :users
  resources :sessions,      only: [:new, :create, :destroy]
  resources :holdings
  resources :utransactions, only: [:create]


  root to: 'static_pages#home'

  match '/signup',                to: 'users#new',                        via: 'get'
  match '/signin',                to: 'sessions#new',                     via: 'get'
  match '/signout',               to: 'sessions#destroy',                 via: 'delete'
  #match '/home',    to: 'static_pages#home',    via: 'get'
  match '/how_works',             to: 'static_pages#how_works',           via: 'get'
  match '/trader_manual',         to: 'static_pages#trader_manual',       via: 'get'
  match '/faq',                   to: 'static_pages#faq',                 via: 'get'
  match '/contact',               to: 'static_pages#contact',             via: 'get'
  match '/about',                 to: 'static_pages#about',               via: 'get'
  match '/economics',             to: 'markets#economics',                via: 'get'
  match '/politics',              to: 'markets#politics',                via: 'get'
  match '/environment',           to: 'markets#environment',                via: 'get'

end
