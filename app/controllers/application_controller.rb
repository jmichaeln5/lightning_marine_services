class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    dashboard_path # path User will be redirected to on login
  end
end
