# class ResourceSort ############ Before Resource Parent Class
class ResourceSort < Resource

  attr_accessor :resource, :sort_option, :sort_direction

  def initialize(resource, sort_option = nil, sort_direction = nil)
    @resource = resource
    @sort_option ||= sort_option
    @sort_direction ||= sort_direction
  end

  def get_resource_class
      Object.const_get @resource.name
  end

  def sortable_orders_ths
    sortable_orders_ths = [
      'id',
      'dept',
      'courrier',
      'date_recieved',
      'date_delivered'
    ]
  end

  def sort_resource
    if sortable_orders_ths.include? @sort_option
      get_resource_class.reorder(sort_option + " " + sort_direction)
    elsif @sort_option == 'ship_name'
      get_resource_class.includes(:purchaser).references(:purchaser).reorder("name" + " " + sort_direction)
    elsif @sort_option == 'vendor_name'
      get_resource_class.includes(:vendor).references(:vendor).reorder("name" + " " + sort_direction)
    else
      get_resource_class.all.order("created_at DESC")
    end
  end



end
