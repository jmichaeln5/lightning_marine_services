module SortableOrders
  extend ActiveSupport::Concern

  included do
    def sort_params
      params.permit(:sort_option, :sort_direction)
    end

    def sort_option
      params[:sort_option]
    end

    def sort_direction
      params[:sort_direction]
    end

    def sort?
      return false if params[:sort_option].nil?
      return false if params[:sort_direction].nil?

      return false unless sort_option.to_s.downcase.in?(Order.sortable_attrs)
      return false unless sort_direction.to_s.downcase.in?(['asc', 'desc'])

      return true
    end

    def sorted_orders(orders)
      return orders.reorder(sort_option => sort_direction) if !(sort_option.in?(%w(vendor_name purchaser_name ship_name)))

      case sort_option
      when 'vendor_name'
        return Order.order_by_vendor_name(sort_direction)
      when 'ship_name'
        return Order.order_by_purchaser_name(sort_direction)
      end
    end
  end
end
