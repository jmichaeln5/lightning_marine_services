module SearchOrdersIndex

  def search_orders_index(search_query)
     # Order.unarchived.reindex
     search_query = Order.search "#{search_query}", where: {archived: false}
     results_arr = Array.new

     search_query.results.each do |result|
       results_arr << result.id
     end

     return Order.unarchived.all.where(id: results_arr)
  end

end
