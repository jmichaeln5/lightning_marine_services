module SearchVendorsIndex

  def search_vendors_index(search_query)
     search_query = Vendor.search(search_query)
     results_arr = Array.new

     search_query.results.each do |result|
       results_arr << result.id
     end

     return Vendor.where(id: results_arr)
  end

end
