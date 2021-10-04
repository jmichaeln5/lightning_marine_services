# module InitResource ### *** Allows hash params to be used as instance variables in InitResourceKlass
#   def set_resource_klass_attrs( options={} )
#     options.each { |k,v| instance_variable_set("@#{k}", v) }
#   end
#
#   def self.say_yo
#     "heyyyyoooo"
#   end
# end
#
# class InitResourceKlass # Defining Class Methods for Resource Klass
#   extend InitResource
#
#   def self.set_sort_resource
#     return @init_sorted_resource = SortResource.new(resource = @parent_class, sort_option = @sort_option, sort_direction = @sort_direction, page = @page)
#     # return @sorted_resource = @init_sorted_resource.sort_resource
#   end
#
#   def self.set_table_options
#     return @init_table_options = ResourceTableOption.new(@user, @parent_class, @parent_action, @page)
#     # return @table_options.table_options
#     # @table_options = @init_table_options
#   end
#
#   def self.my_dood
#     "Ayooooo"
#   end
#
# end
#
#
# class Resource < InitResourceKlass # Resource Class acts as Data Object
#   extend InitResource
#
#   def self.get_resource_struct( options = {} )
#     @resource = Struct.new(*options.keys).new(*options.values)
#     # byebug
#   end
#
#   ### ********* Call Service Classes Here by appeneding on InitResourceKlass
#   def self.present_sorted_orders
#     InitResourceKlass.set_sort_resource.sort_resource
#   end
#
#   def self.present_sort_resource_class
#     InitResourceKlass.set_sort_resource
#   end
#
#   def self.present_table_options
#     InitResourceKlass.set_table_options
#   end
#
#   def self.present_table_options_to_display
#     InitResourceKlass.set_table_options.return_table_options
#   end
#
#   ### ********* Set ivar methods here
#   def self.present_total_pages
#     present_sorted_orders
#
#     resource_amount = present_sorted_orders.count
#     resources_per_page =  present_table_options.resources_per_page
#
#     # return (resource_amount.modulo(resources_per_page) == 0) ? ( (resource_amount / resources_per_page) - 1 ) : (resource_amount / resources_per_page)
#
#     return (resource_amount / resources_per_page)
#   end
#
#   def self.yeet_bruv
#     "Yeetin"
#   end
#
#   # byebug
# end
