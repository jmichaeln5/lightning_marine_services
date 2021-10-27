module SearchOrders

  module SearchOrdersIndex
    autoload :SearchOrdersIndex, "services/searches/search_orders/search_orders_index.rb"
    extend SearchOrdersIndex
  end

  module SearchOrdersAllOrders
    autoload :SearchOrdersAllOrders, "services/searches/search_orders/search_orders_all_orders.rb"
    extend SearchOrdersAllOrders
  end

end
