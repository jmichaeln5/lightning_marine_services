module Sort

  def self.invalid_sort(target, sort_option, sort_direction)
    return target.order("created_at #{sort_direction}")
  end

  def self.trigger_sort_target(resource)
    parent_class = resource.parent_class
    parent_action = resource.parent_action

    # Defining parent and child module method sort_target will be called from
    sort_parent_class_module = "Sort#{resource.controller_name.pluralize.capitalize}"
    sort_parent_action_module = "Sort#{parent_action.camelize}"
    sort_module = "#{sort_parent_class_module}::#{sort_parent_action_module}"

    case sort_module

    when "SortOrders::SortIndex"
      autoload :SortOrders, "services/sorts/sort_orders/sort_orders.rb"
      extend SortOrders
      return SortOrders::SortIndex.sort_target(resource.target, resource.sort_option, resource.sort_direction)

    when "SortOrders::SortAllOrders"
      autoload :SortOrders, "services/sorts/sort_orders/sort_orders.rb"
      extend SortOrders
      return SortOrders::SortAllOrders.sort_target(resource.target, resource.sort_option, resource.sort_direction)

    when "SortVendors::SortIndex"
      autoload :SortVendors, "services/sorts/sort_vendors/sort_vendors.rb"
      extend SortVendors
      return SortVendors::SortIndex.sort_target(resource.target, resource.sort_option, resource.sort_direction)

    when "SortVendors::SortShow"
      autoload :SortVendors, "services/sorts/sort_vendors/sort_vendors.rb"
      extend SortVendors
      return SortVendors::SortShow.sort_target(resource.target, resource.sort_option, resource.sort_direction)

    when "SortPurchasers::SortIndex"
      autoload :SortPurchasers, "services/sorts/sort_purchasers/sort_purchasers.rb"
      extend SortPurchasers
      return SortPurchasers::SortIndex.sort_target(resource.target, resource.sort_option, resource.sort_direction)

    when "SortPurchasers::SortShow"
      autoload :SortPurchasers, "services/sorts/sort_purchasers/sort_purchasers.rb"
      extend SortPurchasers
      return SortPurchasers::SortShow.sort_target(resource.target, resource.sort_option, resource.sort_direction)

    when "SortSearches::SortIndex"
      autoload :SortSearches, "services/sorts/sort_searches/sort_searches.rb"
      extend SortSearches
      return SortSearches::SortIndex.sort_target(resource.target, resource.sort_option, resource.sort_direction)

    else
      return invalid_sort(resource.target, sort_option, sort_direction)
    end

  end
end
