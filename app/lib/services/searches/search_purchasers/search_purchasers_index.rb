module SearchPurchasersIndex

  def search_purchasers_index(search_query)
     Purchaser.reindex
     search_query = Purchaser.search(search_query)
     results_arr = Array.new

     search_query.results.each do |result|
       results_arr << result.id
     end

     return Purchaser.where(id: results_arr)
  end

end
