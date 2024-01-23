module OrdersTableHelper
  extend ActiveSupport::Concern

  include FilterableOrders
  include SortableOrders

  def resolve_orders_for_data_table(orders)
    dev_output_str("OrdersTableHelper#resolve_orders_for_data_table")

    orders = filtered_orders if filter?
    # orders = sort_orders_against_params(orders) if sort_param.present?
    orders = sorted_orders(orders) if sort?

    # if (params[:sort_option].nil? == false) && (params[:sort_direction].nil? == false)
    #   orders = sorted_orders(orders)
    # end



    orders = search_orders_against_query(orders, query_param ) if query_param.present? and query_param.length > 1

    return orders
  end

  def query_param
    params[:query]
  end

  private
    def search_orders_against_query(orders, query_str)
      dev_output_str("OrdersTableHelper#search_orders_against_query")

      results = orders.search(query_str, misspellings: { below: 6} ).results
      results_arr = Array.new
      results.each do |result|
        results_arr << result.id if (result.archived? == false)
      end
      orders = orders.where(id: results_arr)
      return orders
    end

    # def arel_reorder(sorted_orders_ids_arr)
    #   dev_output_str("OrdersTableHelper#arel_reorder")
    #
    #   # https://stackoverflow.com/a/61267426
    #   order_query = <<-SQL
    #     CASE orders.id
    #       #{sorted_orders_ids_arr.map.with_index { |id, index| "WHEN #{id} THEN #{index}" } .join(' ')}
    #       ELSE #{sorted_orders_ids_arr.length}
    #     END
    #   SQL
    #
    #   newly_sorted_orders = Order.where(id: sorted_orders_ids_arr).order(Arel.sql(order_query))
    #   clear_active_record_query_cache
    #
    #   orders = newly_sorted_orders
    #   return orders
    # end
    #
    # def reorder_orders_by_sort_params(orders)
    #   if %w{ id dept date_recieved courrier date_delivered }.include?(sort_param)
    #     orders.reorder(sort_param => sort_direction)
    #   else
    #     orders.order(id: :desc)
    #   end
    # end
    #
    # def ordered_order_ids_from_arent_sort_params(orders)
    #   sorted_orders = Order.where(id: orders.ids).order_by_purchaser_name(sort_direction) if sort_param == "ship_name"
    #   sorted_orders = Order.where(id: orders.ids).order_by_purchaser_name(sort_direction) if sort_param == "purchaser_name"
    #   sorted_orders = Order.where(id: orders.ids).order_by_vendor_name(sort_direction) if sort_param == "vendor_name"
    #
    #   sorted_orders_ids = sorted_orders.ids
    #   sorted_orders_ids_arr = Array.new
    #   sorted_orders_ids.each do |order_id|
    #     sorted_orders_ids_arr << order_id
    #   end
    #   orders = arel_reorder(sorted_orders_ids_arr)
    #
    #   return orders
    # end
    #
    # def sort_orders_against_params(orders)
    #   dev_output_str("OrdersTableHelper#sort_orders_against_params")
    #
    #   if ((sort_param == "ship_name") || ( sort_param == "vendor_name" )) # None Order col
    #     orders = ordered_order_ids_from_arent_sort_params(orders)
    #   end
    #
    #   if ((sort_param != "ship_name") && (sort_param != "purchaser_name") && ( sort_param != "vendor_name" )) # sorting order col
    #     orders = reorder_orders_by_sort_params(orders)
    #   end
    #
    #   return orders
    # end
end
