module OrdersSortTableLogic

  def self.sortable_orders_ths
    %w[
      id
      purchaser_id
      vendor_id
      courrier
      date_recieved
    ]
  end

  def self.non_sortable_orders_ths
    %w[
      po_number
      order_content
    ]
  end

  # def self.sortable_link_to(column, title = nil)
  #   title ||= column.titleize
  #   link_to title, {:sort => column, :direction => direction}
  # end

  def self.sorted_orders(sort_option = nil, sort_direction = nil)
    sort_option ||= nil
    sort_direction ||= nil

    case sort_option
    when 'id'
      @orders = sort_orders_by_id(sort_option, sort_direction)
    when 'courrier'
      @orders = sort_orders_by_courrier(sort_option, sort_direction)
    when 'date_recieved'
      @orders = sort_orders_by_date_recieved(sort_option, sort_direction)
    when 'purchaser_id'
      @orders = sort_orders_purchaser_name(sort_option, sort_direction)
    when 'vendor_id'
      @orders = sort_orders_vendor_name(sort_option, sort_direction)
    else
      @orders = Order.all.order("created_at DESC")
    end
  end

  ## # Seperated into seperate methods for following reasons:
  ######## # 1) Avioding possible Zeitwerk autoloading issues on initial app boot
  ######## # 2) Future feature expansion
  def self.sort_orders_purchaser_name(sort_option, sort_direction)
    @orders = Order.includes(:purchaser).references(:purchaser).reorder("name" + " " + sort_direction)
  end

  def self.sort_orders_vendor_name(sort_option, sort_direction)
    @orders = Order.includes(:vendor).references(:vendor).reorder("name" + " " + sort_direction)
  end

  def self.sort_orders_by_id(sort_option, sort_direction)
    @orders = Order.order(sort_option + " " + sort_direction)
  end

  def self.sort_orders_by_courrier(sort_option, sort_direction)
    @orders = Order.order(sort_option + " " + sort_direction)
  end

  def self.sort_orders_by_date_recieved(sort_option, sort_direction)
    @orders = Order.order(sort_option + " " + sort_direction)
  end

end
