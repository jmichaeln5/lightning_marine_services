module VendorsSortTableLogic

  def self.sorted_vendors(sort_option = nil, sort_direction = nil)
    sort_option ||= nil
    sort_direction ||= nil

    case sort_option
    when 'id'
      @vendors = sort_vendors_by_id(sort_option, sort_direction)
    when 'name'
      @vendors = sort_vendors_by_name(sort_option, sort_direction)
    when 'order_amount'
      @vendors = sort_vendors_by_order_amount(sort_option, sort_direction)
    else
      @vendors = Vendor.all.order("created_at DESC")
    end
  end

  ## # Seperate methods to avoid possible Zeitwerk autoloading issues on initial app boot

  def self.sort_vendors_by_id(sort_option, sort_direction)
    @vendors = Vendor.order(sort_option + " " + sort_direction)
  end

  def self.sort_vendors_by_name(sort_option, sort_direction)
    @vendors = Vendor.order("name #{sort_direction}")
  end

  def self.sort_vendors_by_order_amount(sort_option, sort_direction)
    @most_to_least_orders = Vendor.all.sort {|a,b| b.orders.length <=> a.orders.length}

    if sort_direction == 'asc'
      @vendors = @most_to_least_orders
    elsif sort_direction == 'desc'
      @vendors = @most_to_least_orders.reverse
    end
  end

end
