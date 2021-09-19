module VendorsIndexTableSortLogic

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

  def self.sort_vendors_by_id(sort_option, sort_direction)
    @vendors = Vendor.order(sort_option + " " + sort_direction)
  end

  def self.sort_vendors_by_name(sort_option, sort_direction)
    @vendors = Vendor.order("name #{sort_direction}")
  end

  def self.sort_vendors_by_order_amount(sort_option, sort_direction)
    if sort_direction == 'asc'
      @vendors = Vendor.left_joins(:orders).group(:id).order('COUNT(orders.id) DESC')
    elsif sort_direction == 'desc'
      @vendors = Vendor.left_joins(:orders).group(:id).order('COUNT(orders.id) ASC')
    else
      @vendors = Vendor.all
    end
  end


end
