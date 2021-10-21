module SortIndex

  def sort_target(target, sort_option, sort_direction)
    case sort_option
    when 'id'
      sort_by_sort_option(target, sort_option, sort_direction)
    when 'name'
      sort_by_sort_option(target, sort_option, sort_direction)
    when 'order_amount'
      sort_vendors_by_order_amount(target, sort_option, sort_direction)
    else
      return target.order("created_at DESC")
    end
  end

  def sort_by_sort_option(target, sort_option, sort_direction)
      target.reorder(sort_option + " " + sort_direction)
  end

  def sort_vendors_by_order_amount(target, sort_option, sort_direction)
      Vendor.left_joins(:orders).group(:id).order("COUNT(orders.id) #{sort_direction}")
  end


end
