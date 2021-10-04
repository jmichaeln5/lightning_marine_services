module InitResource ### *** Allows hash params to be used as instance variables in InitResourceKlass
  # def initialize_resource( options={} )
  def set_resource_klass_attrs( options={} )
    options.each { |k,v| instance_variable_set("@#{k}", v) }
    # byebug
  end

  def self.say_yo
    "heyyyyoooo"
  end

  # byebug
end

class InitResourceKlass # Defining Class Methods for Resource Klass
  extend InitResource

  def self.yeet_from_klass
    "yeet self from klass"
  end

  def self.set_sort_resource
    return @init_sorted_resource = SortResource.new(resource = @parent_class, sort_option = @sort_option, sort_direction = @sort_direction, page = @page)
    # return @sorted_resource = @init_sorted_resource.sort_resource
  end

  def self.set_table_options
    return @init_table_options = ResourceTableOption.new(@user, @parent_class, @parent_action, @page)
    # return @table_options.table_options
    # @table_options = @init_table_options
  end

  def self.my_dood
    "Ayooooo"
  end

  # byebug
end
