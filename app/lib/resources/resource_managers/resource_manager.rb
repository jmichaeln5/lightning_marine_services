autoload :ResourceCore, "resources/resource_core.rb"
autoload :ResourceManagerTableOption, "resources/resource_managers/resource_manager_table_options/resource_manager_table_option.rb"
autoload :ResourceManagerPagination, "resources/resource_managers/resource_manager_paginations/resource_manager_pagination.rb"
autoload :ResourceManagerSort, "resources/resource_managers/resource_manager_sorts/resource_manager_sort.rb"
autoload :ServiceManager, "service_managers/service_manager.rb"

module ResourceManager
  extend ResourceCore
  extend ResourceManagerTableOption
  extend ResourceManagerPagination
  extend ResourceManagerSort
  extend ServiceManager

  def self.init_resource_manager( options={} ) # Set ivars to be used in when called in classes below
    options.each { |k,v| instance_variable_set("@#{k}", v) }
    ResourceManagerKlass.set_resource_manager( options )
    ResourceManagerKlass.init_resource( options ) # method extended from ResourceCore
  end

  class ResourceManagerKlass
    extend ResourceCore
    extend ResourceManagerTableOption
    extend ResourceManagerPagination
    extend ResourceManagerSort
    extend ServiceManager

    def self.set_resource_manager( options = {} )
      @resource_manager = Struct.new(*options.keys).new(*options.values)
      init_resource(options)
      @generic_resource = @resource_manager # Using @generic_resource ivar with same name in Resource::ResourceKlass
      @options = options
    end

    def self.resource_manager_my_dood
      "resource_manager_my_dood: Ayooooo"
    end

    def self.set_table_option
      table_option_hash = Hash.new
      if ServiceManagerTableOption::HasTableOption.new.is_satisfied_by?(@generic_resource)
         @table_option = ResourceManagerTableOption.user_table_option(
           user = @generic_resource.user,
           parent_class = @generic_resource.parent_class,
           parent_action = @generic_resource.parent_action,
           page = @generic_resource.page
           )
      else
        @table_option = ResourceManagerTableOption.new_table_option(
          user = @generic_resource.user,
          parent_class = @generic_resource.parent_class,
          parent_action = @generic_resource.parent_action,
          page = @generic_resource.page
          )
      end
    end

    def self.set_pagination
      @pagination =
        ResourceManagerPagination.new_pagination(
          resource = @generic_resource.target,
          resources_per_page = set_table_option.resources_per_page,
          page = @page
          ) unless ServiceManagerPagination::PaginationKlass.new.is_satisfied_by?(@generic_resource)
    end

    def self.set_sort
      if ServiceManagerSort::SortDirection.new.is_satisfied_by?(@generic_resource)
        @sorted_resource =
          ResourceManagerSort.sort_orders(
            target = @generic_resource.target,
            sort_option = @generic_resource.sort_option,
            sort_direction = @generic_resource.sort_direction
          )
      else
        @sorted_resource = @generic_resource.target.order("created_at DESC")
      end
    end

  end
end
