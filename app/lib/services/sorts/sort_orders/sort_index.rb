module SortIndex

  # Change to Case When Else
  def self.sort_target(target, sort_option, sort_direction)
    # if sort_option
    #   sort_by_sort_option(target, sort_option, sort_direction)
    # elsif sort_option == 'ship_name'
    #   sort_by_ship_name(target, sort_option, sort_direction)
    # elsif sort_option == 'vendor_name'
    #   sort_by_vendor_name(target, sort_option, sort_direction)
    # else
    #    return target
    # end

    if sort_option
        case sort_option
        when 'ship_name'
          sort_by_ship_name(target, sort_option, sort_direction)
        when 'vendor_name'
          sort_by_vendor_name(target, sort_option, sort_direction)
        else

          # byebug

          sort_by_sort_option(target, sort_option, sort_direction)
        end
    else
      return target.order("created_at DESC")
    end


  end

  def self.sort_by_sort_option(target, sort_option, sort_direction)
    target.reorder(sort_option + " " + sort_direction)
  end

  def self.sort_by_ship_name(target, sort_option, sort_direction)
    target.includes(:purchaser).references(:purchaser).reorder("name" + " " + sort_direction)
  end

  def self.sort_by_vendor_name(target, sort_option, sort_direction)
    target.includes(:vendor).references(:vendor).reorder("name" + " " + sort_direction)
  end
end
