module OrdersSortTableLogic

  def self.sortable_orders_ths
    sortable_orders_ths = [
      'id',
      'dept',
      'courrier',
      'date_recieved',
      'date_delivered'
    ]
  end

  def self.sorted_orders(sort_option = nil, sort_direction = nil)
    sort_option ||= nil
    sort_direction ||= nil

    if sortable_orders_ths.include? sort_option
      @orders = sort_by_sort_option(sort_option, sort_direction)
    elsif sort_option == 'purchaser_name'
          @orders = sort_orders_purchaser_name(sort_option, sort_direction)
    elsif sort_option == 'vendor_name'
          @orders = sort_orders_vendor_name(sort_option, sort_direction)
    else
      @orders = Order.all.order("created_at DESC")
    end

  end

  def self.sort_by_sort_option(sort_option, sort_direction)
    @orders = Order.reorder(sort_option + " " + sort_direction)
  end

  def self.sort_orders_purchaser_name(sort_option, sort_direction)
    @orders = Order.includes(:purchaser).references(:purchaser).reorder("name" + " " + sort_direction)
  end

  def self.sort_orders_vendor_name(sort_option, sort_direction)
    @orders = Order.includes(:vendor).references(:vendor).reorder("name" + " " + sort_direction)
  end

end
