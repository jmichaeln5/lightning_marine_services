autoload :SortOrders, "services/sorts/sort_orders.rb"

module ResourceManagerSort
  extend SortOrders

  def self.sort_orders(target, sort_option, sort_direction)
    SortOrders.sort_target(target, sort_option, sort_direction)
    # byebug
  end

end
