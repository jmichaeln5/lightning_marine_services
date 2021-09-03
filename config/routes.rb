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

  get '/dashboard', to: 'dashboard#show', as: 'dashboard'

  get '/exports', to: 'exports#index', as: 'export_csv'
  # get '/exports', to: 'exports#index', as: 'export_csv'
  get '/exports/sample_page', to: 'exports#sample_page', as: 'export_sample_page'


  resources :users
  resources :purchasers
  resources :vendors
  resources :orders

  resources :orders do
    resources :attachments do
      delete :destroy_attachment
    end
  end

  # get: '/attachments/:id/destroy_attachment/:id', to: 'attachments_controller#destroy_attachment', as: 'destroy_attachment'

  # delete: '/attachments/:id/destroy_attachment/:id', to: 'attachments_controller#destroy_attachment', as: 'destroy_attachment'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # match '*path' => redirect('/'), :via => [:get, :post]
end
