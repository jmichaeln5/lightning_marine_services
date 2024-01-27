module Orders::ResourceScoped
  extend ActiveSupport::Concern

  included do
    private
      def invoke_scoped_resource_methods
        set_purchaser if purchaser?
        set_vendor if vendor?

        set_resource_class_scoped
        set_scoped_resource
      end

      def resource_param
        params[:resource]
      end

      def valid_resource_params
        %w(purchasers vendors)
      end

      def resource_param_valid?
        resource_param.in? valid_resource_params
      end

      def scoped_resource?
        params.fetch(:route_scoped?, false)

        return false if params[:resource].nil?
        return false unless resource_param_valid?

        resource_param_valid?
      end
      alias_method :set_scoped_resource?, :scoped_resource?

      def purchaser?
        params.dig(:purchaser_id) ? true : false
      end

      def vendor?
        params.dig(:vendor_id) ? true : false
      end

      def set_purchaser
        @purchaser = Purchaser.find(params[:purchaser_id])
      end

      def set_vendor
        @vendor = Vendor.find(params[:vendor_id])
      end

      def get_resource_scoped_class
        return Purchaser.name if purchaser?
        return Vendor.name if vendor?
      end

      def set_resource_class_scoped
        @resource_class_scoped = get_resource_scoped_class
      end

      def get_scoped_resource
        return Purchaser.find(params[:purchaser_id]) if purchaser?
        return Vendor.find(params[:vendor_id]) if vendor?
      end

      def set_scoped_resource
        @scoped_resource = get_scoped_resource
      end

      def set_new_scoped_resource_order
        set_scoped_resource if @scoped_resource.nil?
        @order = @scoped_resource.orders.build
      end
  end
end
