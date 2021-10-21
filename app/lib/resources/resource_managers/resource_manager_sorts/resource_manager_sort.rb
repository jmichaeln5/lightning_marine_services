# autoload :SortOrders, "services/sorts/sort_orders/sort_orders.rb"
# autoload :SortVendors, "services/sorts/sort_vendors/sort_vendors.rb"
autoload :Sort, "services/sorts/sort.rb"

module ResourceManagerSort
  extend Sort
  def self.manage_sort(resource)
    Sort.trigger_sort_target(resource)
  end

end
