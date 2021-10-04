class SortResource < Resource

  attr_accessor :resource, :sort_option, :sort_direction, :page

  def initialize(resource, sort_option = nil, sort_direction = nil, page = nil)
    @resource = resource
    @sort_option = sort_option
    @sort_direction = sort_direction
    @page = page
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

  # def sort_resource
  def sort_resource
    if (@sort_option != nil) && (@sort_direction != nil)
        if sortable_orders_ths.include? sort_option
          return @resource.reorder(sort_option + " " + sort_direction)
        elsif sort_option == 'ship_name'
          return @resource.includes(:purchaser).references(:purchaser).reorder("name" + " " + sort_direction)
        elsif sort_option == 'vendor_name'
          return @resource.includes(:vendor).references(:vendor).reorder("name" + " " + sort_direction)
        else
          return @resource.all
        end
    else
        return @resource.all
    end
  end

  def output_resource(resource, sort_option = nil, sort_direction = nil)
    if (sort_option != nil) && (sort_direction != nil)
      sort_option ||= sort_option
      sort_direction ||= sort_direction
      @resource
      return " Sorting #{sort_option} by: #{sort_direction} "
    end
  end

end
