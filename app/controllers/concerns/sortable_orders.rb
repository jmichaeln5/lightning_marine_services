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

      _sort_option = (sort_option == 'ship_name') ? 'purchaser_name' : sort_option
      _attr_name = _sort_option.downcase.gsub("_name", "")

      return Order.where(id: orders.ids).includes(_attr_name.to_sym).references(_attr_name.to_sym).order("LOWER(name)" + " " + sort_direction)
    end
  end
end