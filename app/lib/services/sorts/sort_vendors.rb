module SortVendors

    def self.sortable_orders_ths
      [
        'id',
        'vendor_name',
        'order_amount'
      ]
    end

    def self.sort_target(target, sort_option, sort_direction)

      # byebug

      case sort_option
      when 'id'
        sort_vendors_by_id(target, sort_option, sort_direction)
      when 'name'
        sort_vendors_by_name(target, sort_option, sort_direction)
      when 'order_amount'
        sort_vendors_by_order_amount(sort_option, sort_direction)
      else
        return target
      end
    end

    def self.sort_vendors_by_id(target, sort_option, sort_direction)
      target.order(sort_option + " " + sort_direction)
    end

    def self.sort_vendors_by_name(target, sort_option, sort_direction)
      target.order("name #{sort_direction}")
    end


    def self.sort_vendors_by_order_amount(sort_option, sort_direction)
      # byebug
        Vendor.left_joins(:orders).group(:id).order("COUNT(orders.id) #{sort_direction}")
    end

end
