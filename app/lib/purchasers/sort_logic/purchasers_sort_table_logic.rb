module PurchasersSortTableLogic

  def self.sorted_purchasers(sort_option = nil, sort_direction = nil)
    sort_option ||= nil
    sort_direction ||= nil

    case sort_option
    when 'id'
      @purchasers = sort_purchasers_by_id(sort_option, sort_direction)
    when 'name'
      @purchasers = sort_purchasers_by_name(sort_option, sort_direction)
    when 'order_amount'
      @purchasers = sort_purchasers_by_order_amount(sort_option, sort_direction)
    else
      @purchasers = Purchaser.all.order("created_at DESC")
    end
  end

  ## # Seperated into seperate methods for following reasons:
  ######## # 1) Avioding possible Zeitwerk autoloading issues on initial app boot
  ######## # 2) Future feature expansion

  def self.sort_purchasers_by_id(sort_option, sort_direction)
    @purchasers = Purchaser.order(sort_option + " " + sort_direction)
  end

  def self.sort_purchasers_by_name(sort_option, sort_direction)
    @purchasers = Purchaser.order("name #{sort_direction}")
  end

  def self.sort_purchasers_by_order_amount(sort_option, sort_direction)
    @most_to_least_orders = Purchaser.all.sort {|a,b| b.orders.length <=> a.orders.length}

    if sort_direction == 'asc'
      @purchasers = @most_to_least_orders
    elsif sort_direction == 'desc'
      @purchasers = @most_to_least_orders.reverse
    end
  end

end
