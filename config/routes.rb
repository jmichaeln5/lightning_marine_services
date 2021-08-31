Rails.application.routes.draw do
  namespace :admin do
      resources :users
      resources :order_contents
      resources :orders
      resources :purchasers
      resources :vendors

      root to: "users#index"
    end
  root 'pages#home'
  get 'pages/about'

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
    delete 'signout', to: 'users/sessions#destroy'
  end

  get '/exports', to: 'exports#index', as: 'export_csv'
  # get '/exports', to: 'exports#index', as: 'export_csv'
  get '/exports/sample_page', to: 'exports#sample_page', as: 'export_sample_page'


  resources :users
  resources :purchasers
  resources :vendors
  resources :orders

  # get '/orders/:id/export_csv', to: 'orders#export_csv' , as: 'export_csv'


  # post '/orders/:order_id/create_order_from_order', to: 'orders#create', as: 'create_order_from_order_path'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
