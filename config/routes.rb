Rails.application.routes.draw do

  get 'feedback/new'

  resources :markets do
    member do
      get 'close'
      get 'graph_data'
      post 'hold'
    end
    resources :contracts, shallow: true do
      post 'after_close', on: :collection
    end
  end

  resources :utransactions do
    member do
      get 'simulate'
    end
  end

  resources :users
  resources :sessions,      only: [:new, :create, :destroy]
  resources :holdings do
    post 'cash_out'
  end
  resources :utransactions, only: [:new, :create]
  resources :bhistories,    only: [:new, :create]
  resources :microposts, only: [:create, :destroy]
  resources :password_resets
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  root to: 'static_pages#home'

  match '/signup',                to: 'users#new',                        via: 'get'
  match '/signin',                to: 'sessions#new',                     via: 'get'
  match '/signin',                to: 'sessions#create',                  via: 'post'
  match '/signout',               to: 'sessions#destroy',                 via: 'delete'
  match '/signout',               to: 'sessions#destroy',                 via: 'get'
  #match '/home',    to: 'static_pages#home',    via: 'get'
  match '/howtoplay',             to: 'static_pages#howtoplay',           via: 'get'
  match '/player_manual',         to: 'static_pages#player_manual',       via: 'get'
  match '/faq',                   to: 'static_pages#faq',                 via: 'get'
  match '/contact',               to: 'static_pages#contact',             via: 'get'
  match '/about',                 to: 'static_pages#about',               via: 'get'
  match '/trade_history',         to: 'utransactions#index',              via: 'get'
  match '/my_orders',             to: 'holdings#index',                   via: 'get'
  match '/bank_history',          to: 'bhistories#index',                 via: 'get'
  match '/feedback/new',          to: 'feedback#new',                     via: 'post'
  match '/feedback/form',         to: 'feedback#form',                    via: 'get'
  match '/update_ranking',        to: 'users#update_ranking',             via: 'get'

  get "utransactions/new" => 'utransactions#new', :as => :new_transaction


end
