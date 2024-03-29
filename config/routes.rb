Rails.application.routes.draw do
  root 'static_pages#landing'
  get '/about', to: 'static_pages#about'

  namespace :admin do
    root to: "users#index"
    resources :users
    resources :roles, only: %i(index show)
  end

  devise_for :users, skip: %i(sessions registrations passwords)
  devise_scope :user do # Users::SessionsController
    get 'users/sign_in', to: 'users/sessions#new', as:'new_user_session'
    post 'users/sign_in', to: 'users/sessions#create', as:'user_session'
    get 'users/sign_out', to: 'users/sessions#destroy', as:'destroy_user_session'
    delete 'users/sign_out', to: 'users/sessions#destroy'
  end
  devise_scope :user do # Users::RegistrationsController
    get '/users/sign_up', to: 'users/registrations#new', as:'new_user_registration'
    post '/users/sign_up', to: 'users/registrations#create'
    get '/account_settings', to: 'users/registrations#edit', as:'edit_user_registration'
    put '/users/edit', to: 'users/registrations#update', as:'user_registration'
    delete '/users/edit', to: 'users/registrations#destroy'
    delete '/users', to: 'users/registrations#destroy'
    get '/users/cancel', to: 'users/registrations#cancel', as:'cancel_user_registration'
    delete '/users/cancel', to: 'users/registrations#cancel'
  end
  devise_scope :user do # Users::PasswordsController
    get '/users/password/new', to: 'users/passwords#new', as:'new_user_password' # forgot password
    get '/users/password/edit', to: 'users/passwords#edit', as:'edit_user_password'
    patch '/users/password', to: 'users/passwords#update'
    put '/users/password', to: 'users/passwords#update'
  end

  get '/dashboard', to: 'dashboard#show', as: 'dashboard'

  resources :directory_links

  resources :table_options

  concern :hovercardable do
    member do
      get :hovercard
    end
  end

  resources :searches, only: %i(index)

  concern :destroy_attachable do
    delete '/attachments/:signed_id', action: 'destroy_attachment'
  end

  concern :statusable do
    resources :statuses, only: %i(edit update show)
  end
  resources :statuses, only: %i(edit update show)

  concern :exportable do
    get :export
    post :export
  end

  resources :orders, concerns: %i(hovercardable statusable) do
    collection do
      concerns :exportable
    end
    member do
      get :edit_dept
      concerns :destroy_attachable
    end
  end

  concern :orders_scoped do
    resources :orders, only: %i(index new create), defaults: { route_scoped?: true, resource: @scope.frame.dig(:controller) } do
      collection do
        get '/new', to: 'orders#new'
        get '(/:status)', to: 'orders#index'
        concerns :exportable
        patch '/update', to: 'orders/bulk#update'
      end
    end
  end

  resources :purchasers, except: :show do
    concerns :orders_scoped
  end

  resources :vendors, except: :show do
    concerns :orders_scoped
  end

  resources :order_contents, only: %i(show edit update destroy)

  resources :packaging_materials, only: %i(show new edit update destroy), concerns: %i(statusable)

  resources :order_contents, only: %i(show) do
    resources :packaging_materials, controller: 'order_contents/packaging_materials', only: %i(new index create)
  end

  def generate_order_content_packaging_material_types_routes
    %i(new index create).each do |_action_name|
      PackagingMaterial::Packageable::TYPE_NAMES.each do |packaging_material_type|
        type = packaging_material_type.to_s.downcase.singularize

        case _action_name
        when :new
          get "/order_contents/:order_content_id/packaging_materials/#{type.pluralize}/new",
            to: "order_contents/packaging_materials#new",
            as: "new_order_content_packaging_material_#{type.singularize}".to_sym,
            type: type.classify
        when :index
          get "/order_contents/:order_content_id/packaging_materials/#{type.pluralize}",
            to: 'order_contents/packaging_materials#index',
            as: "order_content_packaging_material_#{type.pluralize}".to_sym,
            type: type.classify
        when :create
          post "/order_contents/:order_content_id/packaging_materials/#{type.pluralize}",
            to: "order_contents/packaging_materials#create",
            type: type.classify
        end
      end
    end
  end

  generate_order_content_packaging_material_types_routes
end
