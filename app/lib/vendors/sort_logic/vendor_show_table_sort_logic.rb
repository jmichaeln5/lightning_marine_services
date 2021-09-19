module VendorShowTableSortLogic

  def self.sorted_vendor_orders(vendor, sort_option = nil, sort_direction = nil)
    @vendor = Vendor.find(vendor.id)

    sort_option ||= nil
    sort_direction ||= nil

    case sort_option
    when 'id'
      @orders = sort_by_sort_option(sort_option, sort_direction)
    when 'ship_name'
      @orders = sort_vendor_orders_by_ship_name(sort_option, sort_direction)
    when 'date_recieved'
      @orders = sort_by_sort_option(sort_option, sort_direction)
    when 'courrier'
      @orders = sort_by_sort_option(sort_option, sort_direction)
    when 'date_delivered'
      @orders = sort_by_sort_option(sort_option, sort_direction)
    else
      @orders = @vendor.orders.order("created_at DESC")
    end

  end

  def self.sort_by_sort_option(sort_option, sort_direction)
    @orders = @vendor.orders.reorder(sort_option + " " + sort_direction)
  end

  def self.sort_vendor_orders_by_ship_name(sort_option, sort_direction)
    @orders =  @vendor.orders.includes(:purchaser).references(:purchaser).reorder("name" + " " + sort_direction)
  end

end
