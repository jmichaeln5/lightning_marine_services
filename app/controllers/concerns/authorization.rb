module Authorization
  extend ActiveSupport::Concern

  private

    def authorized_admin?
      return false unless Current.user.has_role? :admin
      return true
    end

    def authorize_admin
      veto_unauthorized_request unless authorized_admin?
    end

    def authorized_internal_user?
      return true if Current.user.has_role? :admin
      return true if Current.user.has_role? :staff
      return false
    end

    def authorize_internal_user
      veto_unauthorized_request unless authorized_internal_user?
    end

    def authorized_customer?
      return true if Current.user.has_role? :customer
      return false
    end

    def authorize_customer
      return true if authorized_customer?
      return true if authorized_internal_user?
      veto_unauthorized_request
    end

    def render_turbo_stream_unauthorized_request_message
      render turbo_stream: turbo_stream.append(
        'flashes',
        partial: "/layouts/stacked_shell/headings/flash_messages",
        locals: {
          flash_type: "alert",
          flash_title: 'Not authorized.',
        }
      ), status: :unauthorized
    end

    def veto_unauthorized_http_request
      redirect_back fallback_location: dashboard_path, alert: 'Not authorized.'
    end

    def veto_unauthorized_request
      render_turbo_stream_unauthorized_request_message and return if turbo_frame_request?
      veto_unauthorized_http_request
    end

    def silently_veto_unauthorized_request
      redirect_back fallback_location: dashboard_path unless turbo_frame_request?
    end

end
