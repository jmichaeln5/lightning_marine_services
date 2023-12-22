Rails.application.routes.draw do
  resources :directory_links

  root 'static_pages#landing'
  get '/about', to: 'static_pages#about'

  namespace :admin do
    root to: "users#index"
    resources :users
    resources :roles, only: [:index, :show]
  end

  devise_for :users, skip: [ :sessions, :registrations, :passwords ]

  # Users::SessionsController
  devise_scope :user do
    get 'users/sign_in', to: 'users/sessions#new', as:'new_user_session'
    post 'users/sign_in', to: 'users/sessions#create', as:'user_session'
    get 'users/sign_out', to: 'users/sessions#destroy', as:'destroy_user_session'
    delete 'users/sign_out', to: 'users/sessions#destroy'
  end
  # Users::RegistrationsController
  devise_scope :user do
    get '/users/sign_up', to: 'users/registrations#new', as:'new_user_registration'
    post '/users/sign_up', to: 'users/registrations#create'

    get '/account_settings', to: 'users/registrations#edit', as:'edit_user_registration'
    put '/users/edit', to: 'users/registrations#update', as:'user_registration'
    delete '/users/edit', to: 'users/registrations#destroy'

    delete '/users', to: 'users/registrations#destroy'
    get '/users/cancel', to: 'users/registrations#cancel', as:'cancel_user_registration'
    delete '/users/cancel', to: 'users/registrations#cancel'
  end
  # Users::PasswordsController
  devise_scope :user do
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

  # namespace :orders do
  #   resource :bulk, controller: :bulk, only: [:destroy]
  # end

  resources :searches, only: [:index]

  concern :searchable do
    scope module: 'searches' do
      get 'search'
    end
  end

  concern :destroy_attachable do
    delete '/attachments/:signed_id', action: 'destroy_attachment'
  end

  resources :orders, concerns: [:hovercardable ] do
    collection do
      concerns :searchable
    end

    member do
      get :edit_dept
      concerns :destroy_attachable
    end
  end

  resources :orders do
    resources :order_contents, controller:'orders/order_contents', only: [:create]
  end
  resources :order_contents, only: [:show, :edit, :update, :destroy]

  resources :packaging_materials, only: [:show, :edit, :update, :destroy]
  # resources :packaging_materials, only: [:show], as: :packaging_material_box, type: 'Box'
  get '/packaging_materials/:id', to: 'packaging_materials#show', as: :packaging_material_box, type: 'Box'
  get '/packaging_materials/:id', to: 'packaging_materials#show', as: :packaging_material_crate, type: 'Crate'
  get '/packaging_materials/:id', to: 'packaging_materials#show', as: :packaging_material_pallet, type: 'Pallet'

  resources :order_contents, only: [:show] do  # NOTE # should match  # resources :packaging_materials, controller: :packaging_materials, only: [:index, :new, :create],  module: :order_contents, as: :order_content_packaging_materials
    resources :packaging_materials, controller: 'order_contents/packaging_materials', only: [:index, :new, :create]
  end
  # resources :packaging_materials, controller: :packaging_materials, module: :order_contents, only: [:index, :new, :create], as: :order_content_packaging_materials

  # get '/order_contents/:order_content_id/packaging_materials/boxes', to: 'order_contents/packaging_materials#index', as: :order_content_packaging_materials_boxes, type: 'Box'         # NOTE # OrderContents::PackagingMaterials#new - THROWS ERROR WHEN PLURAL
  # get '/order_contents/:order_content_id/packaging_materials/crates', to: 'order_contents/packaging_materials#index', as: :order_content_packaging_materials_crates, type: 'Crate'     # NOTE # OrderContents::PackagingMaterials#new - THROWS ERROR WHEN PLURAL
  # get '/order_contents/:order_content_id/packaging_materials/pallets', to: 'order_contents/packaging_materials#index', as: :order_content_packaging_materials_pallets, type: 'Pallet'  # NOTE # OrderContents::PackagingMaterials#new - THROWS ERROR WHEN PLURAL
  get '/order_contents/:order_content_id/packaging_materials/boxes', to: 'order_contents/packaging_materials#index', as: :order_content_packaging_material_boxes, type: 'Box'                ###  using 👈🏾  because ☝🏾 ☝🏾 ☝🏾
  get '/order_contents/:order_content_id/packaging_materials/crates', to: 'order_contents/packaging_materials#index', as: :order_content_packaging_material_crates, type: 'Crate'            ###  using 👈🏾  because ☝🏾 ☝🏾 ☝🏾
  get '/order_contents/:order_content_id/packaging_materials/pallets', to: 'order_contents/packaging_materials#index', as: :order_content_packaging_material_pallets, type: 'Pallet'         ###  using 👈🏾  because ☝🏾 ☝🏾 ☝🏾



  get '/order_contents/:order_content_id/packaging_materials/new/boxes', to: 'order_contents/packaging_materials#new', as: :new_order_content_packaging_material_box, type: 'Box'
  get '/order_contents/:order_content_id/packaging_materials/new/crates', to: 'order_contents/packaging_materials#new', as: :new_order_content_packaging_material_crate, type: 'Crate'
  get '/order_contents/:order_content_id/packaging_materials/new/pallets', to: 'order_contents/packaging_materials#new', as: :new_order_content_packaging_material_pallet, type: 'Pallet'

  post '/order_contents/:order_content_id/packaging_materials/boxes', to: 'order_contents/packaging_materials#create', type: 'Box'
  post '/order_contents/:order_content_id/packaging_materials/crates', to: 'order_contents/packaging_materials#create', type: 'Crate'
  post '/order_contents/:order_content_id/packaging_materials/pallets', to: 'order_contents/packaging_materials#create', type: 'Pallet'


  resources :purchasers do
    resources :orders, only: [:index, :new, :create ], module: :purchasers do
      get 'deliver_active', on: :collection
    end

    member do
      get 'all_orders', controller: 'purchasers/orders'
      get 'active_orders', controller: 'purchasers/orders'
      get 'completed_orders', controller: 'purchasers/orders'

      get :export
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
  get '/completed_orders', to: 'orders#completed_orders'

  get '/purchasers_all', to: 'purchasers#show_all'
  #get '/all_ship_orders/:id', to: 'purchasers#show_all'
  # get '/search', to: 'searches#index'

  # Redirects to root if invalid path BUT, fucks up search params
  # match '*path' => redirect('/'), :via => [:get, :post]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end



###########################
###########################
###########################
###########################
# resources :articles do
#   resources :comments, only: [:index, :new, :create]
# end
# resources :comments, only: [:show, :edit, :update, :destroy]
