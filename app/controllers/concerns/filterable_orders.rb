module FilterableOrders
  extend ActiveSupport::Concern

  included do
    def filter_params
      params.require(:filter).permit(:dept, courrier:[], status: [])
    end

    def filter?
      return false if params[:filter].nil?
      _filter_params = params[:filter].compact_blank!
      _filter_params.keys.collect {|key| _filter_params["#{key}"].try("compact_blank!".to_sym) }
      _filter_params.compact_blank!

      _filter_params.blank? ? false : true
    end

    def filter_orders
      filters = filter_params.to_hash
      Order.filter(filters)
    end
  end
end
