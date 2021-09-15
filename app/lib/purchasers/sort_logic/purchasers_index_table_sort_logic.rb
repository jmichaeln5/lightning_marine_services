module PurchasersIndexTableSortLogic

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

  ## # Seperate methods to avoid possible Zeitwerk autoloading issues on initial app boot
  def self.sort_purchasers_by_id(sort_option, sort_direction)
    @purchasers = Purchaser.order(sort_option + " " + sort_direction)
  end

  def self.sort_purchasers_by_name(sort_option, sort_direction)
    @purchasers = Purchaser.order("name #{sort_direction}")
  end

  def self.sort_purchasers_by_order_amount(sort_option, sort_direction)
    if sort_direction == 'asc'
      @purchasers = Purchaser.left_joins(:orders).group(:id).order('COUNT(orders.id) DESC')
    elsif sort_direction == 'desc'
      @purchasers = Purchaser.left_joins(:orders).group(:id).order('COUNT(orders.id) ASC')
    else
      @purchasers = Purchaser.all
    end
  end

end
