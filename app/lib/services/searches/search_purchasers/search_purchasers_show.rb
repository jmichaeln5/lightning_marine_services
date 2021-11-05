module SearchPurchasersShow

  def search_purchasers_show(resource)

    resource.target.first.purchaser.orders.reindex
    purchaser_instance = Purchaser.find(resource.target.first.purchaser_id)
    search_directory = Order.all.where(purchaser_id: purchaser_instance.id)
    inquiring_keyword = resource.search_query
    results_arr = Array.new

    search_directory.search(inquiring_keyword).results.each do |result|
     results_arr << result.id
    end

    return purchaser_instance.orders.where(id: results_arr)
  end

  # def search_purchasers_show(resource)
  #   # byebug
  #   purchaser_instance = Purchaser.find(resource.target.first.purchaser.id)
  #   # search_directory = Order.all.search "#{resource.search_query}", where: {purchaser_id: purchaser_instance}
  #
  #   search_directory = Order.search "#{resource.search_query}"
  #
  #   results_arr = Array.new
  #   search_directory.results.each do |result|
  #     # byebug
  #    results_arr << result.id if result.purchaser.id == purchaser_instance
  #   end
  #
  #   return Order.where(id: results_arr)
  # end




end
