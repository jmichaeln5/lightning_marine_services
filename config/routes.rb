Rails.application.routes.draw do
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


  resources :users
  resources :purchasers
  resources :vendors
  resources :orders
  resources :order_contents

  # resources :orders do
  #   # resources :details, only: [:index, :new, :create]
  #   # resources :detail, only: [:index, :new, :create]
  #   resources :detail
  # end
  # # resources :details, only: [:show, :update, :destroy]
  # resources :detail, only: [:show, :update, :destroy]


  # resources :details, :controllers => {
  #   :registrations => 'users/registrations',
  #   :sessions => 'users/sessions',
  #   :passwords => 'users/passwords',
  #   :confirmations => 'users/confirmations'
  #  }

  # resources :orders do
  #   resources :details, shallow: true
  # end



  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
