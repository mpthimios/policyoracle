Rails.application.routes.draw do

 
  get 'bhistories/index'

  resources :markets do
    resources :contracts, shallow: true
  end

  resources :markets do
    member do
      get 'close'
    end
  end

  resources :contracts do
    member do
      post 'after_close'
    end
  end

  resources :users
  resources :sessions,      only: [:new, :create, :destroy]
  resources :holdings
  resources :utransactions, only: [:new, :create]
  resources :bhistories,    only: [:create]
  resources :microposts, only: [:create, :destroy]


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
  match '/trade_history',         to: 'utransactions#index',              via: 'get'
  match '/my_orders',             to: 'holdings#index',                   via: 'get'
  match '/bank_history',          to: 'bhistories#index',                 via: 'get'

  get "utransactions/new" => 'utransactions#new', :as => :new_transaction

end
