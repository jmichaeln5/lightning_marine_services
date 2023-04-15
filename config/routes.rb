Rails.application.routes.draw do
  resources :directory_links
  root 'pages#home'
  get 'pages/about'

  namespace :admin do
      resources :users
      resources :roles, only: [:index, :show]
      root to: "users#index"
  end

  # devise_for :users
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions',
    :passwords => 'users/passwords',
    :confirmations => 'users/confirmations'
   }

  devise_scope :user do
    get 'sign_up', to: 'users/registrations#new'
    get 'sign_in', to: 'users/sessions#new'
    get 'signout', to: 'users/sessions#destroy'
    delete 'signout', to: 'users/sessions#destroy'
  end

  get '/dashboard', to: 'dashboard#show', as: 'dashboard'

  resources :users
  resources :table_options

  concern :hovercardable do
    member do
      get :hovercard
    end
  end

  concern :searchable do
    collection do
      resources :searches, only: [:index]
    end
  end

  resources :searches, only: [:index]

  resources :orders, concerns: [:searchable, :hovercardable ]


  namespace :orders do
    resource :bulk, controller: :bulk, only: [:destroy]
  end

  resources :orders do
    resources :attachments do
      delete :destroy_attachment
    end
  end

  get '/purchasers/:purchaser_id/all_orders', to: 'purchasers/orders#all_orders',  as: 'all_purchaser_orders'
  get '/purchasers/:purchaser_id/active_orders', to: 'purchasers/orders#active_orders',  as: 'active_purchaser_orders'

  resources :purchasers do
    resources :orders, only: [:index, :new, :create], module: :purchasers

    member do
      get :export
      get :deliver
    end
  end

  get '/vendors/:vendor_id/all_orders', to: 'vendors/orders#all_orders',  as: 'all_vendor_orders'
  get '/vendors/:vendor_id/active_orders', to: 'vendors/orders#active_orders',  as: 'active_vendor_orders'

  resources :vendors do
  # resources :vendors, concerns: [:searchable ] do
    resources :orders, only: [:index, :new, :create], module: :vendors
  end

  get '/archived_orders', to: 'orders#archived_index'
  get '/all_orders', to: 'orders#all_orders'

  get '/purchasers_all', to: 'purchasers#show_all'
  #get '/all_ship_orders/:id', to: 'purchasers#show_all'
  # get '/search', to: 'searches#index'

  # resources :purchasers do
  #   member do
  #     get :export
  #     get :deliver
  #   end
  # end

  # Redirects to root if invalid path BUT, fucks up search params
  # match '*path' => redirect('/'), :via => [:get, :post]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
