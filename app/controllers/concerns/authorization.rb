module Authorization
  extend ActiveSupport::Concern

  private

    def authenticate_admin
      refuse_unauthorized_request unless current_user.has_role? 'admin'
    end

    def exclude_customer
      refuse_unauthorized_request if current_user.has_role?('customer')
    end

    def check_read_write # Admins and Staff have Read Write Access
      if ! (current_user.has_role?('admin') || current_user.has_role?('staff'))
        refuse_unauthorized_request
      end
    end

    def turbo_frame_refuse_unauthorized_request
      render turbo_stream: turbo_stream.append(
        'flashes',
        partial: "/layouts/stacked_shell/headings/flash_messages",
        locals: {
          flash_type: "alert",
          flash_title: 'Not authorized.',
        }
      ), status: :unauthorized
    end

    def refuse_unauthorized_request
      turbo_frame_refuse_unauthorized_request and return if turbo_frame_request?
      redirect_back fallback_location: dashboard_path, alert: 'Not authorized.'
    end

end
