module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate, if: :controller_requires_authentication?
  end

  private

    def authenticate
      redirect_to sign_in_path, alert: 'Not authorized.' unless user_signed_in?
      Current.user = current_user
    end

    # https://api.rubyonrails.org/classes/ActiveSupport/CurrentAttributes.html
    # def authenticate
    #   if authenticated_user = User.find_by(id: cookies.encrypted[:user_id])
    #     Current.user = authenticated_user
    #   else
    #     redirect_to new_session_url
    #   end
    # end
    # https://api.rubyonrails.org/v5.1/classes/ActionDispatch/Cookies.html

    def controller_requires_authentication?
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
