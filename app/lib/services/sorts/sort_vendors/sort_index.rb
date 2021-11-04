module SortIndex

  def sort_target(target, sort_option, sort_direction)
    case sort_option
    when 'id'
      return sort_by_sort_option(target, sort_option, sort_direction)
    when 'name'
      return sort_by_sort_option(target, sort_option, sort_direction)
    when 'order_amount'
      return sort_vendors_by_order_amount(target, sort_option, sort_direction)
    else
      return target
    end
  end

  def sort_by_sort_option(target, sort_option, sort_direction)
    return Vendor.reorder(sort_option + " " + sort_direction)
  end

  def sort_vendors_by_order_amount(target, sort_option, sort_direction)
    target = nil
    target = Vendor.left_joins(:orders).group(:id).reorder("COUNT(orders.id) #{sort_direction}")
    return target
  end

end
