Rails.application.routes.draw do
  root 'pages#index'
  devise_for :users

  get 'pages/about'
  # get 'users/dashboard'
  get '/dashboard' => 'users#dashboard'


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
