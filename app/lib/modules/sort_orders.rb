module SortOrders

  def get_resource_class
    super
  end

  def sortable_orders_ths
    [
      'id',
      'dept',
      'courrier',
      'date_recieved',
      'date_delivered'
    ]
  end

  def sort_resource(resource, sort_option = nil, sort_direction = nil)
    if (sort_option != nil) && (sort_direction != nil)

      sort_option ||= sort_option
      sort_direction ||= sort_direction
      get_resource_class

      if sortable_orders_ths.include? sort_option
        # get_resource_class.reorder(sort_option + " " + sort_direction)
        return get_resource_class.reorder(sort_option + " " + sort_direction)
      elsif sort_option == 'ship_name'
        # get_resource_class.includes(:purchaser).references(:purchaser).reorder("name" + " " + sort_direction)
        return get_resource_class.includes(:purchaser).references(:purchaser).reorder("name" + " " + sort_direction)
      elsif sort_option == 'vendor_name'
        # get_resource_class.includes(:vendor).references(:vendor).reorder("name" + " " + sort_direction)
        return get_resource_class.includes(:vendor).references(:vendor).reorder("name" + " " + sort_direction)
      else
        # get_resource_class.all.order("created_at DESC")
        return get_resource_class.all.order("created_at DESC")
      end

    end
  end

  # def output_resource(resource, sort_option = nil, sort_direction = nil)
  #   if (sort_option != nil) && (sort_direction != nil)
  #     sort_option ||= sort_option
  #     sort_direction ||= sort_direction
  #     get_resource_class
  #     return " Sorting #{sort_option} by: #{sort_direction} "
  #   end
  # end

end
