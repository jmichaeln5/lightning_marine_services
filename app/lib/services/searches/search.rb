module Search

  def self.get_search_module(resource)
    parent_class = resource.parent_class.name
    parent_action = resource.parent_action
    search_parent_class_module = "Search#{parent_class.pluralize}"
    search_parent_action_module = "#{search_parent_class_module}#{parent_action.camelize}"
    return "#{search_parent_class_module}::#{search_parent_action_module}"
  end

  def self.search_resource(resource)

    # byebug

    case get_search_module(resource)

    when "SearchOrders::SearchOrdersIndex"
      autoload :SearchOrders, "services/searches/search_orders/search_orders.rb"
      extend SearchOrders::SearchOrdersIndex
      return SearchOrders::SearchOrdersIndex.search_orders_index(resource.search_query)

    when "SearchOrders::SearchOrdersAllOrders"
      autoload :SearchOrders, "services/searches/search_orders/search_orders.rb"
      extend SearchOrders::SearchOrdersAllOrders
      return SearchOrders::SearchOrdersAllOrders.search_orders_all_orders(resource.search_query)

    when "SearchPurchasers::SearchPurchasersIndex"
      autoload :SearchPurchasers, "services/searches/search_purchasers/search_purchasers.rb"
      extend SearchPurchasers::SearchPurchasersIndex
      return SearchPurchasers::SearchPurchasersIndex.search_purchasers_index(resource.search_query)

    when "SearchPurchasers::SearchPurchasersShow"
      autoload :SearchPurchasers, "services/searches/search_purchasers/search_purchasers.rb"
      extend SearchPurchasers::SearchPurchasersShow
      return SearchPurchasers::SearchPurchasersShow.search_purchasers_show(resource.search_query)

    when "SearchVendors::SearchVendorsIndex"
      autoload :SearchVendors, "services/searches/search_vendors/search_vendors.rb"
      extend SearchVendors::SearchVendorsIndex
      return SearchVendors::SearchVendorsIndex.search_vendors_index(resource.search_query)

    when "SearchVendors::SearchVendorsShow"
        autoload :SearchVendors, "services/searches/search_vendors/search_vendors.rb"
        extend SearchVendors::SearchVendorsShow
        return SearchVendors::SearchVendorsShow.search_vendors_show(resource.search_query)
    end

  end

end
