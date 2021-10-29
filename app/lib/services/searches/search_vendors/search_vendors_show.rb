module SearchVendorsShow

  def search_vendors_show(search_query)
     Vendor.orders.reindex
     search_query = Vendor.orders.search(search_query)
     results_arr = Array.new

     search_query.results.each do |result|
       results_arr << result.id
     end

     return Vendor.orders.where(id: results_arr)
  end

end
