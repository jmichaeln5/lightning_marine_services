autoload :InitResource, "resource/init_resource.rb"
autoload :InitResourceKlass, "resource/init_resource.rb"

module InitResourceClass
  def get_resource_class_attrs( options={} )
    options.each { |k,v| instance_variable_set("@#{k}", v) }
  end

  # byebug
end

class Resource < InitResourceKlass # Resource Class acts as Data Object
  extend InitResourceClass

  def self.get_resource_struct( options = {} )
    @resource = Struct.new(*options.keys).new(*options.values)
    # byebug
  end

  ### ********* Call Service Classes Here by appeneding on InitResourceKlass
  def self.present_sorted_orders
    InitResourceKlass.set_sort_resource.sort_resource
  end

  def self.present_sort_resource_class
    InitResourceKlass.set_sort_resource
  end

  def self.present_table_options
    InitResourceKlass.set_table_options
  end

  def self.present_table_options_to_display
    InitResourceKlass.set_table_options.return_table_options
  end

  ### ********* Set ivar methods here
  def self.present_total_pages
    present_sorted_orders

    resource_amount = present_sorted_orders.count
    resources_per_page =  present_table_options.resources_per_page

    # return (resource_amount.modulo(resources_per_page) == 0) ? ( (resource_amount / resources_per_page) - 1 ) : (resource_amount / resources_per_page)

    return (resource_amount / resources_per_page)
  end

  def self.yeet_bruv
    "Yeetin"
  end

  # byebug
end
