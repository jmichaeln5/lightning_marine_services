module Orders::ResourceScoped
  extend ActiveSupport::Concern

  included do
    private
      def resource_param
        params[:resource]
      end

      def valid_resource_params
        %w(purchasers vendors)
      end

      def valid_resource_param?
        resource_param.in? valid_resource_params
      end

      def scoped_resource?
        params.fetch(:route_scoped?, false) && valid_resource_param? && (purchaser? || vendor?)
      end

      def purchaser?
        params.dig(:purchaser_id) ? true : false
      end

      def vendor?
        params.dig(:vendor_id) ? true : false
      end

      def get_scoped_resource
        return Purchaser.includes(:orders).find(params[:purchaser_id]) if purchaser?
        return Vendor.includes(:orders).find(params[:vendor_id]) if vendor?
      end

      def set_scoped_resource
        @scoped_resource = get_scoped_resource
      end

      def set_scoped_resource_orders
        @orders = @scoped_resource.orders.where(status: status_scopes).reorder(order_sequence: :asc) if purchaser?
        @orders = @scoped_resource.orders.where(status: status_scopes).reorder(id: :desc) if vendor?
      end
  end
end
