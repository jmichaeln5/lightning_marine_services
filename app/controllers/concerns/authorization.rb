module Authorization
  extend ActiveSupport::Concern

  private

    def authorize_admin
      veto_unauthorized_request unless Current.user.has_role? 'admin'
    end

    def authorize_editors
      authorized_editor = false
      authorized_editor = true if Current.user.has_role? 'admin'
      authorized_editor = true if Current.user.has_role? 'staff'

      veto_unauthorized_request unless authorized_editor
    end

    def exclude_customer
      veto_unauthorized_request if current_user.has_role?('customer')
    end

    def check_read_write # Admins and Staff have Read Write Access
      if ! (current_user.has_role?('admin') || current_user.has_role?('staff'))
        veto_unauthorized_request
      end
    end

    def veto_unauthorized_turbo_frame_request
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
      veto_unauthorized_turbo_frame_request and return if turbo_frame_request?
      veto_unauthorized_http_request
    end

end
