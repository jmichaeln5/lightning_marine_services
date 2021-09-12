module SortTableLogicTwo

  def self.sorted_orders(sort_order_by = nil, sort_direction = nil)
      sort_order_by ||= sort_order_by
      sort_direction ||= nil

      case sort_order_by
        when 'id'
          @orders = sort_resource_by_id(sort_direction)

        when 'purchaser_id'
          @orders = sort_resource_by_purchaser_name(sort_direction)

        when 'vendor_id'
          @orders = sort_resource_by_vendor_name(sort_direction)

        when 'courrier'
          @orders = sort_resource_by_courrier(sort_direction)

        when 'date_recieved'
          @orders = sort_resource_by_date_recieved(sort_direction)

        else
          @orders = Order.all.order("created_at DESC")
      end
  end

  # Seperating into Methods incase further break down in future + Protecting against SQL injection
  def self.sort_resource_by_id(sort_direction)
    @orders = Order.order( "id" + " " + sort_direction )
  end

  def self.sort_resource_by_purchaser_name(sort_direction)
    @orders = Order.includes(:purchaser).references(:purchaser).reorder("name" + " " + sort_direction)
  end

  def self.sort_resource_by_vendor_name(sort_direction)
    @orders = Order.includes(:vendor).references(:vendor).reorder("name" + " " + sort_direction)
  end

  def self.sort_resource_by_courrier(sort_direction)
    @orders = Order.order( "courrier" + " " + sort_direction )
  end

  def self.sort_resource_by_date_recieved(sort_direction)
    @orders = Order.order( "date_recieved" + " " + sort_direction )
  end

end # end of module
