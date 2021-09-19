module PurchasersIndexTableSortLogic

  def self.sortable_purchasers_ths
    sortable_purchasers_ths = [
      'id',
      'name'
    ]
  end

  def self.sorted_purchasers(sort_option = nil, sort_direction = nil)
    sort_option ||= nil
    sort_direction ||= nil

    if sortable_purchasers_ths.include? sort_option
      @purchasers = sort_by_sort_option(sort_option, sort_direction)
    elsif sort_option == 'order_amount'
      @purchasers = sort_purchasers_by_order_amount(sort_option, sort_direction)
    else
      @purchasers = Purchaser.all.order("created_at DESC")
    end
  end

  def self.sort_by_sort_option(sort_option, sort_direction)
    @purchasers = Purchaser.reorder(sort_option + " " + sort_direction)
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
