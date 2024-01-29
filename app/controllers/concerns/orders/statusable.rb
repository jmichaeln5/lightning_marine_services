module Orders::Statusable
  extend ActiveSupport::Concern

  included do
    private
      def status_param
        params[:status]
      end

      def valid_status_params
        %w(all active completed)
      end

      def status_param_valid?
        status_param.in? valid_status_params
      end

      def scoped_status?
        return false if params[:status].nil?
        return false unless status_param_valid?

        status_param_valid?
      end

      def scoped_status
        return "all" unless (scoped_status? && status_param_valid?)
        status_param
      end

      def status_scopes(status_scope: nil)
        status_scope ||= status_param if status_scope.nil?

        case status_scope
        when "all"
          return Order.statuses.values
        when "active"
          return Order.active_statuses.values
        when "completed"
          return Order.inactive_statuses.values
        else
          return Order.statuses.values
        end
      end

      def status_display_name(status_scope: nil)
        status_scope ||= status_param if status_scope.nil?
        status_scope.in?(valid_status_params) ? status_scope : "all"
      end
  end
end
