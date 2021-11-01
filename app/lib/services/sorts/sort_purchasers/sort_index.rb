module SortIndex

  def sort_target(target, sort_option, sort_direction)
    case sort_option
    when 'id'
      return sort_by_sort_option(target, sort_option, sort_direction)
    when 'name'
      return sort_by_sort_option(target, sort_option, sort_direction)
    when 'order_amount'
      return sort_purchasers_by_order_amount(target, sort_option, sort_direction)
    else
      target.order("created_at #{sort_direction}")
    end
  end

  def sort_by_sort_option(target, sort_option, sort_direction)
    return Purchaser.reorder(sort_option + " " + sort_direction)
  end

  def sort_purchasers_by_order_amount(target, sort_option, sort_direction)

    target = nil

    target = Purchaser.left_joins(:orders).group(:id).reorder("COUNT(orders.id) #{sort_direction}")

    return target

  end

end