module Sort
  # Used in extended Sort Modules in app/lib/services/sorts/*
  def self.invalid_sort(target, sort_option, sort_direction)
    return target.order("created_at #{sort_direction}")
  end

  def self.trigger_sort_target(resource)
    target = resource.target
    parent_class = resource.parent_class
    parent_action = resource.parent_action
    sort_option = resource.sort_option
    sort_direction = resource.sort_direction

    # Defining parent and child module method sort_target will be called from
    sort_parent_class_module = "Sort#{parent_class.name.pluralize}"
    sort_parent_action_module = "Sort#{parent_action.capitalize}"
    sort_module = "#{sort_parent_class_module}::#{sort_parent_action_module}"

    case sort_module

    when "SortOrders::SortIndex"
      autoload :SortOrders, "services/sorts/sort_orders/sort_orders.rb"
      extend SortOrders
      return SortOrders::SortIndex.sort_target(target, sort_option, sort_direction)

    when "SortVendors::SortIndex"

      autoload :SortVendors, "services/sorts/sort_vendors/sort_vendors.rb"
      extend SortVendors
      return SortVendors::SortIndex.sort_target(target, sort_option, sort_direction)

    when "SortVendors::SortShow"
      autoload :SortVendors, "services/sorts/sort_vendors/sort_vendors.rb"
      extend SortVendors
      return SortVendors::SortShow.sort_target(target, sort_option, sort_direction)

    else
      return invalid_sort(target, sort_option, sort_direction)
    end

  end
end
