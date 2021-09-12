module OrdersSortTableLogic

  def self.sorted_orders(sort_option = nil, sort_direction = nil)
    sort_option ||= nil
    sort_direction ||= nil

    case sort_option
    when 'id' || 'courrier' || 'date_recieved'
      @orders = sort_resource(sort_option, sort_direction)
    when 'purchaser_id' || 'vendor_id'
      @orders = sort_resource_by_name(sort_option, sort_direction)
    else
      @orders = Order.all.order("created_at DESC")
    end
  end

  def self.sort_resource(sort_option, sort_direction)
    @orders = Order.order( sort_option + " " + sort_direction )
  end

  def self.sort_resource_by_name(sort_option, sort_direction)
    @orders = Order.includes(sort_option).references(sort_option).reorder("name" + " " + sort_direction)
  end

end
