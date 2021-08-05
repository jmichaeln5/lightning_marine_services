class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  protected

  def configure_permitted_parameters
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone_number, :email, :username])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone_number, :email, :username, :password, :password_confirmation])

    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone_number, :email, :username])

    # devise_parameter_sanitizer.permit(:account_update, keys: [:phone_number])

  end

end
