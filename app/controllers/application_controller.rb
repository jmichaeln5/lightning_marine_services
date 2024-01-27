class ApplicationController < ActionController::Base
  include SetCurrentRequestDetails
  include Authentication
  include Authorization
  include Pagy::Backend
  include TurboFlashable

  before_action :configure_permitted_parameters, if: :devise_controller?

  # before_action :set_request_variant

  helper_method %i(
    format_datetime_now_str
    authorized_admin?
    authorized_internal_user?
    authorized_customer?
  )

  def format_datetime_now_str
    DateTime.now.try(:strftime,"%m/%d/%Y")
  end

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def after_sign_up_path_for(resource)
    redirect_back
  end

  def dev_output_str(str)
    return unless Rails.env.development?
    puts (" \n")*5
    puts ("*"*50 + "\n")
    puts (" #{str} \n")*5
    puts ("*"*50 + "\n")
    puts (" \n")*5
  end

  def clear_active_record_query_cache
    dev_output_str("ApplicationController#clear_active_record_query_cache") if Rails.env.development?

    ActiveRecord::Base.connection.query_cache.clear
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone_number, :email, :username, :bypass_email_confirmation, :confirmed_at, role_ids: []])

      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone_number, :email, :username])
    end

  private

    # def set_request_variant
      # request.variant = :turbo_frame if turbo_frame_request?
    #   # request.variant = Current.request_variant
    # end

    def ensure_frame_response
      if  Rails.env.development? and !turbo_frame_request?
        puts (" \n")*10
        puts ("*"*50 + "\n")*10
        puts "\n\nMESSAGE FROM: ApplicationController#ensure_frame_response\n\nStarted #{request.method} \"#{request.path}\" for #{request.ip} at #{Time.now}"
        puts "Processing by #{request.controller_class}##{request.params[:action]} as HTML"
        puts "\n\n#{request.controller_class}##{request.params[:action]} has invoked ApplicationController#ensure_frame_response\nRequest vetoed.\nturbo_frame_request? != true\n\n"
        puts ("*"*50 + "\n")*10
        puts (" \n")*10
      end
      # return unless Rails.env.development?
      silently_veto_unauthorized_request
    end

end
