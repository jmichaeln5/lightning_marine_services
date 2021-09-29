autoload :SortOrders, "modules/sort_orders.rb"

class Resource
  include SortOrders

  attr_accessor :user, :parent_class

  def initialize(user, parent_class)
    @user = user
    @parent_class = parent_class
  end

  def self.get_sorted_orders

  end

  def get_resource_class
      Object.const_get @parent_class.name
  end

end
