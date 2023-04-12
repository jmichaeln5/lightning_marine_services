module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
  end

  private

    def controllers_elected_for_authentication
      [
        'DashboardController',
        'OrdersController',
        'VendorsController',
        'PurchasersController',
        'Vendors::OrdersController',
        'Purchasers::OrdersController',
      ]
    end

    def refuse_unauthenticated_turbo_frame
      render turbo_stream: turbo_stream.append(
        'flashes',
        partial: "/layouts/stacked_shell/headings/flash_messages",
        locals: {
          flash_type: "alert",
          flash_title: 'Not authorized.',
        }
      ), status: :unauthorized
    end

    def refuse_unauthenticated
      refuse_unauthenticated_turbo_frame and return if turbo_frame_request?
      redirect_back fallback_location: sign_in_path, alert: 'Not authorized.'
    end

    def authenticate
      if authenticated_user = current_user
        Current.user = authenticated_user
      else
        refuse_unauthenticated if request.controller_class.to_s.in? controllers_elected_for_authentication
      end
    end

end
