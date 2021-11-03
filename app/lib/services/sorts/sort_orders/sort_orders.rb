module SortOrders

  module SortIndex
    autoload :SortIndex, "services/sorts/sort_orders/sort_index.rb"
    extend SortIndex
  end

  module SortAllOrders
    autoload :SortAllOrders, "services/sorts/sort_orders/sort_all_orders.rb"
    extend SortAllOrders
  end

end
