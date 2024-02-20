module Orders::Sortable
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

    def valid_sort_param?
      sort_option.to_sym.downcase.in?(Order.sortable_attrs)
    end

    def valid_sort_direction?
      sort_direction.to_s.downcase.in?(['asc', 'desc'])
    end

    def sort?
      return false if params[:sort_direction].blank?
      return false if params[:sort_option].blank?

      valid_sort_param? && valid_sort_direction?
    end

    def sort_orders_by_order_attribute(orders, attribute, direction)
      orders.reorder(attribute => direction)
    end

    def sort_orders_by_order_parent_name(orders, direction)
      parent_model_name = :purchaser if ((sort_option == 'ship_name') || (sort_option == 'purchaser_name'))
      parent_model_name = :vendor if (sort_option == 'vendor_name')

      Order.where(id: orders.ids)
       .includes(parent_model_name)
       .references(parent_model_name)
       .order("LOWER(name)" + " " + sort_direction)
    end

    def sort_orders(orders)
      return orders unless sort?

      ### NOTE SORTING NIL AND "" VALUES for string data type attributes
      ### e.g. sorting ascending
      ### "" (👈🏾  empty string) will appear before populated string value
      ### "foo" string value will appear in between empty string and nil values
      ### nil values will appear last

      sort_option_sym = sort_option.to_sym

      if sort_option_sym.in? Order.attribute_names.map(&:to_sym)
        return sort_orders_by_order_attribute(orders, sort_option_sym, sort_direction)
      else
        return sort_orders_by_order_parent_name(orders, sort_direction)
      end
    end
  end
end
