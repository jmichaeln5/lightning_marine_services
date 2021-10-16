module SortOrders

    def self.sortable_orders_ths
      [
        'id',
        'dept',
        'courrier',
        'date_recieved',
        'date_delivered'
      ]
    end

    def self.sort_target(target, sort_option, sort_direction)
      if sortable_orders_ths.include? sort_option
        sort_by_sort_option(target, sort_option, sort_direction)
      elsif sort_option == 'ship_name'
        sort_by_ship_name(target, sort_option, sort_direction)
      elsif sort_option == 'vendor_name'
        sort_by_vendor_name(target, sort_option, sort_direction)
      else
         return target
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
