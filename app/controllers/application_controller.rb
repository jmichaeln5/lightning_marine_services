class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    puts " "
    puts "*"*10
    puts " "
    puts "redirecting to dashboard_path"
    puts " "
    puts "*"*10
    puts " "
    # root_path
    dashboard_path
  end

  def after_sign_up_path_for(resource)
    puts " "
    puts "*"*10
    puts " "
    puts "redirecting back for sign up"
    puts " "
    puts "*"*10
    puts " "
    redirect_back
  end

  def authenticate_admin
    redirect_to root_path, alert: 'Not authorized.' unless current_user.has_role?(:admin)
  end

  def authenticate_staff
    redirect_to root_path, alert: 'Not authorized.' unless current_user.has_role?(:staff)
  end


  protected

  def configure_permitted_parameters
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone_number, :email, :username, role_ids: []])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone_number, :email, :username, :bypass_email_confirmation, role_ids: []])

    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone_number, :email, :username])
  end

end
