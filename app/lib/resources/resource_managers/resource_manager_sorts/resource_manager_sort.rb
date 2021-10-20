autoload :SortOrders, "services/sorts/sort_orders.rb"
autoload :SortVendors, "services/sorts/sort_vendors.rb"

module ResourceManagerSort
  extend SortOrders
  extend SortVendors

  def self.sort_resource(resource)

    # byebug

    if resource.parent_class.name == 'Order'

      SortOrders.sort_target(
        target = resource.target,
        sort_option = resource.sort_option,
        sort_direction = resource.sort_direction
      )

    elsif resource.parent_class.name == 'Vendor'

      # byebug

      SortVendors.sort_target(
        target = resource.target,
        sort_option = resource.sort_option,
        sort_direction = resource.sort_direction
      )

    else
      return resource.target
    end

  end

end
