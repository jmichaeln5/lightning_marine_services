module OrdersTableHelper
  extend ActiveSupport::Concern

  include FilterableOrders, SortableOrders

  def resolve_orders_for_data_table(orders)
    dev_output_str("OrdersTableHelper#resolve_orders_for_data_table")

    orders = filter_orders(orders) if filter?
    orders = sort_orders(orders) if sort?
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
end
