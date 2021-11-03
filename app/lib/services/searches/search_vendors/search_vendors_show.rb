module SearchVendorsShow

  def search_vendors_show(resource)

    resource.target.first.vendor.orders.reindex
    vendor_instance = Vendor.find(resource.target.first.vendor_id)
    search_directory = Order.all.where(vendor_id: vendor_instance.id)
    inquiring_keyword = resource.search_query
    results_arr = Array.new

    search_directory.search(inquiring_keyword).results.each do |result|
     results_arr << result.id
    end

    return vendor_instance.orders.where(id: results_arr)
  end

end
