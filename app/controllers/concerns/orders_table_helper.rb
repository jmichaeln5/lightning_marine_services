module OrdersTableHelper
  extend ActiveSupport::Concern

  def resolve_orders_for_data_table(orders)
    dev_output_str("OrdersTableHelper#resolve_orders_for_data_table")

    orders = sort_orders_against_params(orders, params[:sort] ) if params[:sort].present?

    orders = search_orders_against_query(orders, params[:query] ) if params[:query].present? and params[:query].length > 1

    return orders
  end

  private

  def search_orders_against_query(orders, query_str)
    dev_output_str("OrdersTableHelper#search_orders_against_query")

    results = orders.search(query_str, misspellings: { below: 6} ).results
    results_arr = Array.new
    results.each do |result|
      results_arr << result.id if (result.archived? == false)
    end
    # orders = orders.reorder('id ASC')
    orders = orders.where(id: results_arr)
    return orders
  end

  def arel_reorder(sorted_orders_ids_arr)
    dev_output_str("OrdersTableHelper#arel_reorder")

    # https://stackoverflow.com/a/61267426
    order_query = <<-SQL
      CASE orders.id
        #{sorted_orders_ids_arr.map.with_index { |id, index| "WHEN #{id} THEN #{index}" } .join(' ')}
        ELSE #{sorted_orders_ids_arr.length}
      END
    SQL

    newly_sorted_orders = Order.where(id: sorted_orders_ids_arr).order(Arel.sql(order_query))
    clear_active_record_query_cache

    orders = newly_sorted_orders
    return orders
  end

  def sort_orders_against_params(orders, sort_param)
    dev_output_str("OrdersTableHelper#sort_orders_against_params")

    sort_col = %w{ id dept date_recieved courrier date_delivered }.include?(params[:sort]) ? params[:sort] : "id"
    sort_dir = %w{ asc desc }.include?(params[:direction]) ? params[:direction] : "asc"

    if ((params[:sort] == "ship_name") || ( params[:sort] == "vendor_name" )) # None Order col
      sorted_orders = Order.where(id: orders.ids).filter_by_purchasers(sort_dir) if params[:sort] == "ship_name"
      sorted_orders = Order.where(id: orders.ids).filter_by_purchasers(sort_dir) if params[:sort] == "purchaser_name"
      sorted_orders = Order.where(id: orders.ids).filter_by_vendors(sort_dir) if params[:sort] == "vendor_name"

      sorted_orders_ids = sorted_orders.ids
      sorted_orders_ids_arr = Array.new
      sorted_orders_ids.each do |order_id|
        sorted_orders_ids_arr << order_id
      end

      orders = arel_reorder(sorted_orders_ids_arr)
    end

    if ((params[:sort] != "ship_name") && (params[:sort] != "purchaser_name") && ( params[:sort] != "vendor_name" )) # sorting order col
      orders = orders.reorder(sort_col => sort_dir)
    end

    return orders
  end

end
