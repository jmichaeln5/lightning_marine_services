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

    def sort_orders(orders)
      return orders unless sort?

      return orders.reorder(sort_option => sort_direction) unless sort_option.in?(Order.sortable_attrs - Order.attribute_names)

      _sort_option = (sort_option == 'ship_name') ? 'purchaser_name' : sort_option
      _sort_option = _sort_option.downcase.gsub("_name", "")

      return Order.where(id: orders.ids).includes(_sort_option.to_sym).references(_sort_option.to_sym).order("LOWER(name)" + " " + sort_direction)
    end
  end
end
