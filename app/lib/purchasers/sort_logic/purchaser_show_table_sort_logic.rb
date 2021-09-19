module PurchaserShowTableSortLogic

  def self.sorted_purchaser_orders(purchaser, sort_option = nil, sort_direction = nil)
    @purchaser = Purchaser.find(purchaser.id)

    sort_option ||= nil
    sort_direction ||= nil

    case sort_option
    when 'id'
      @orders = sort_by_sort_option(sort_option, sort_direction)
    when 'vendor_name'
      @orders = sort_purchaser_orders_by_vendor_name(sort_option, sort_direction)
    when 'date_recieved'
      @orders = sort_by_sort_option(sort_option, sort_direction)
    when 'courrier'
      @orders = sort_by_sort_option(sort_option, sort_direction)
    when 'date_delivered'
      @orders = sort_by_sort_option(sort_option, sort_direction)
    else
      @orders = @purchaser.orders.order("created_at DESC")
    end

  end

  def self.sort_by_sort_option(sort_option, sort_direction)
    @orders = @purchaser.orders.reorder(sort_option + " " + sort_direction)
  end

  def self.sort_purchaser_orders_by_vendor_name(sort_option, sort_direction)
    @orders =  @purchaser.orders.includes(:vendor).references(:vendor).reorder("name" + " " + sort_direction)
  end

end
