Rails.application.routes.draw do
  resources :directory_links
  root 'static_pages#landing'
  get '/about', to: 'static_pages#about'

  namespace :admin do
    root to: "users#index"
    resources :users
    resources :roles, only: [:index, :show]
  end

  # devise_for :users, controllers: {
  #   sessions: 'users/sessions',
  #   passwords: 'users/passwords',
  #   confirmations: 'users/confirmations',
  # }
  #
  # devise_scope :user do
  #   get 'sign_in', to: 'users/sessions#new'
  #   # get 'users/sign_out', to: 'users/sessions#destroy'
  #   # delete 'users/sign_out', to: 'users/sessions#destroy'
  # end

  devise_for :users, skip: [ :sessions, :registrations, :passwords ]

  devise_scope :user do  # Users::SessionsController
    get 'users/sign_in', to: 'users/sessions#new', as:'new_user_session'
    post 'users/sign_in', to: 'users/sessions#create', as:'user_session'
    get 'users/sign_out', to: 'users/sessions#destroy', as:'destroy_user_session'
    delete 'users/sign_out', to: 'users/sessions#destroy'
  end

  devise_scope :user do  # Users::RegistrationsController
    get '/users/sign_up', to: 'users/registrations#new', as:'new_user_registration'
    post '/users/sign_up', to: 'users/registrations#create'

    get '/account_settings', to: 'users/registrations#edit', as:'edit_user_registration'
    put '/users/edit', to: 'users/registrations#update', as:'user_registration'
    delete '/users/edit', to: 'users/registrations#destroy'

    delete '/users', to: 'users/registrations#destroy'
    get '/users/cancel', to: 'users/registrations#cancel', as:'cancel_user_registration'
    delete '/users/cancel', to: 'users/registrations#cancel'
  end

  devise_scope :user do  # Users::PasswordsController
    get '/users/password/new', to: 'users/passwords#new', as:'new_user_password' # forgot password
    get '/users/password/edit', to: 'users/passwords#edit', as:'edit_user_password'

    patch '/users/password', to: 'users/passwords#update'
    put '/users/password', to: 'users/passwords#update'
  end


  get '/dashboard', to: 'dashboard#show', as: 'dashboard'

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

  # namespace :orders do
  #   resource :bulk, controller: :bulk, only: [:destroy]
  # end

  resources :orders, concerns: [:searchable, :hovercardable ] do
    member do
      get :edit_dept
    end
    resources :attachments do
      delete :destroy_attachment
    end
  end

  resources :purchasers do
    resources :orders, only: [:index, :new, :create ], module: :purchasers

    member do
      get 'all_orders', controller: 'purchasers/orders'
      get 'active_orders', controller: 'purchasers/orders'
      get 'completed_orders', controller: 'purchasers/orders'

      get :export
      get :deliver
    end
  end

  resources :vendors do
    resources :orders, only: [:index, :new, :create ], module: :vendors

    member do
      get 'all_orders', controller: 'vendors/orders'
      get 'active_orders', controller: 'vendors/orders'
      get 'completed_orders', controller: 'vendors/orders'
    end
  end

  get '/archived_orders', to: 'orders#archived_index'
  get '/all_orders', to: 'orders#all_orders'

  get '/purchasers_all', to: 'purchasers#show_all'
  #get '/all_ship_orders/:id', to: 'purchasers#show_all'
  # get '/search', to: 'searches#index'

  # Redirects to root if invalid path BUT, fucks up search params
  # match '*path' => redirect('/'), :via => [:get, :post]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
