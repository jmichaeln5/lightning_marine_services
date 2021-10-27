## Search Action Goes Here
## Search Action Goes Here
## Search Action Goes Here
## Search Action Goes Here
## Search Action Goes Here

module SearchOrdersIndex

  def search_orders_index(search_query)

     Order.unarchived.reindex

     search_query = Order.unarchived.search(search_query)

     results_arr = Array.new

     search_query.results.each do |result|
       results_arr << result.id
     end

     return Order.where(id: results_arr)

  end

end
