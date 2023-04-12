module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_login, if: :controller_requires_login?
  end

  private

    def require_login
      redirect_to sign_in_path, alert: 'Not authorized.' unless user_signed_in?
    end

    def controller_requires_login?
      controllers_without_authentication = [
        'PagesController',
        'Users::SessionsController',
        'Users::ConfirmationsController',
        'Users::UnlocksController',
      ]
      controller_requested_by_navigator = request.controller_class.to_s
      return true unless controller_requested_by_navigator.in? controllers_without_authentication
    end

end
