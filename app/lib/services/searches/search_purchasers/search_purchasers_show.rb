module SearchPurchasersShow

  def search_purchasers_show(search_query)
     Purchaser.orders.reindex
     search_query = Purchaser.orders.search(search_query)
     results_arr = Array.new

     search_query.results.each do |result|
       results_arr << result.id
     end
     
     return Purchaser.orders.where(id: results_arr)
  end

end
