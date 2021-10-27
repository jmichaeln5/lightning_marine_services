module Search

  def self.get_search_module(resource)
    parent_class = resource.parent_class.name
    parent_action = resource.parent_action
    search_parent_class_module = "Search#{parent_class.pluralize}"
    search_parent_action_module = "#{search_parent_class_module}#{parent_action.camelize}"
    return "#{search_parent_class_module}::#{search_parent_action_module}"
  end

  def self.search_resource(resource)
    case get_search_module(resource)

    when "SearchOrders::SearchOrdersIndex"
      autoload :SearchOrders, "services/searches/search_orders/search_orders.rb"
      extend SearchOrders::SearchOrdersIndex
      return SearchOrders::SearchOrdersIndex.search_orders_index(resource.search_query)

    when "SearchOrders::SearchOrdersAllOrders"
      autoload :SearchOrders, "services/searches/search_orders/search_orders.rb"
      extend SearchOrders::SearchOrdersAllOrders
      return SearchOrders::SearchOrdersAllOrders.search_orders_all_orders(resource.search_query)
    end
  end
  
end
