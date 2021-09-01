Rails.application.routes.draw do
  namespace :admin do
      resources :users

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


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  match '*path' => redirect('/'), :via => [:get, :post]
end
