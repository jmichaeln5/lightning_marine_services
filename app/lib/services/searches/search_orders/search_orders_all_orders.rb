module SearchOrdersAllOrders

  def search_orders_all_orders(search_query)
     # Order.reindex
     search_query = Order.search(search_query)
     results_arr = Array.new

     search_query.results.each do |result|
       results_arr << result.id
     end

     return Order.where(id: results_arr)
  end

end
