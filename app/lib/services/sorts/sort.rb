autoload :SortOrders, "services/sorts/sort_orders/sort_orders.rb"
autoload :SortVendors, "services/sorts/sort_vendors/sort_vendors.rb"

module Sort
  extend SortOrders
  extend SortVendors

  def self.trigger_sort_target(resource)
    target = resource.target
    parent_class = resource.parent_class
    parent_action = resource.parent_action
    sort_option = resource.sort_option
    sort_direction = resource.sort_direction

    sort_parent_class_module = self.const_get("Sort#{parent_class.name.pluralize}")
    sort_parent_action_module = self.const_get("Sort#{parent_action.capitalize}")

    # Defining parent and child module sort_target will be called from
    sort_module = const_get("#{sort_parent_class_module}::#{sort_parent_action_module}")
    # byebug
    return sort_module.sort_target(target, sort_option, sort_direction)
  end
end
