module SortIndex

    def sort_target(target, sort_option, sort_direction)
      case sort_option
      when 'id'
        return sort_by_sort_option(target, sort_option, sort_direction)
      when 'dept'
        return sort_by_sort_option(target, sort_option, sort_direction)
      when 'courrier'
        return sort_by_sort_option(target, sort_option, sort_direction)
      when 'date_recieved'
        return sort_by_sort_option(target, sort_option, sort_direction)
      when 'date_delivered'
        return Sort.invalid_sort(target, sort_option, sort_direction)
      when 'ship_name'
        return sort_by_ship_name(sort_option, sort_direction)
      when 'vendor_name'
        return sort_by_vendor_name(sort_option, sort_direction)
      else
        return Sort.invalid_sort(target, sort_option, sort_direction)
      end
    end

    def sort_by_sort_option(target, sort_option, sort_direction)
      return target.reorder(sort_option + " " + sort_direction)
    end

    def sort_by_ship_name(sort_option, sort_direction)
      return Order.unarchived.includes(:purchaser).references(:purchaser).reorder("name" + " " + sort_direction)
    end

    def sort_by_vendor_name(sort_option, sort_direction)
      return Order.unarchived.includes(:vendor).references(:vendor).reorder("name" + " " + sort_direction)
    end
  end
