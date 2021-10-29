autoload :ResourceCore, "resources/resource_core.rb"
autoload :ResourceManagerSearch, "resources/resource_managers/resource_manager_searches/resource_manager_search.rb"
autoload :ResourceManagerTableOption, "resources/resource_managers/resource_manager_table_options/resource_manager_table_option.rb"
autoload :ResourceManagerPagination, "resources/resource_managers/resource_manager_paginations/resource_manager_pagination.rb"
autoload :ResourceManagerSort, "resources/resource_managers/resource_manager_sorts/resource_manager_sort.rb"
autoload :ServiceManager, "service_managers/service_manager.rb"

module ResourceManager
  extend ResourceCore
  extend ResourceManagerSearch
  extend ResourceManagerTableOption
  extend ResourceManagerPagination
  extend ResourceManagerSort
  extend ServiceManager

  def self.init_resource_manager( options={} ) # Set ivars to be used in when called in classes below
    # options.each { |k,v| instance_variable_set("@#{k}", v) }
    ResourceManagerKlass.set_resource_manager( options )
    ResourceManagerKlass.init_resource( options ) # method extended from ResourceCore
  end

  class ResourceManagerKlass
    extend ResourceCore
    extend ResourceManagerSearch
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

    def self.update_resource_manager( options = {} )
      Struct.new(*options.keys).new(*options.values)
    end

    def self.set_search
      if ServiceManagerSearch::HasSearchQuery.new.is_satisfied_by?(@generic_resource)
        @search_query = ResourceManagerSearch.manage_search(resource = @generic_resource)
      else
        @search_query = @generic_resource.target
      end
    end

    def self.set_sort
      if ServiceManagerSort::SortDirection.new.is_satisfied_by?(@generic_resource)
          @sorted_resource = ResourceManagerSort.manage_sort(resource = @generic_resource)
      else
        @sorted_resource = @generic_resource.target.order("created_at DESC")
      end
      # raise StandardError.new "ResourceManager::ResourceManagerKlass: @sorted_resource is nil, cannot continue to next service." if @sorted_resource == nil
    end

    def self.set_table_option
      # byebug

      # spec = has_table_option_for_index_action = ServiceManager::Composite.new(
      # ServiceManagerTableOption::HasTableOption)
      # .and(ServiceManagerTableOption::IsIndexAction)
      # .not(ServiceManagerTableOption::IsShowAction)
      #
      # spec.is_satisfied_by?(@generic_resource)


      # has_table_option_for_show_action = ServiceManager::Composite.new(
      # ServiceManagerTableOption::HasTableOption)
      # .and(ServiceManagerTableOption::IsShowAction)
      # .not(ServiceManagerTableOption::IsIndexAction)

      # ServiceManagerTableOption::HasTableOption.new.is_satisfied_by?(@generic_resource)
      # ServiceManagerTableOption::IsIndexAction.new.is_satisfied_by?(@generic_resource)
      # ServiceManagerTableOption::IsShowAction.new.is_satisfied_by?(@generic_resource)

      # byebug

      if ServiceManagerTableOption::HasTableOption.new.is_satisfied_by?(@generic_resource)
        @table_option = ResourceManagerTableOption.user_table_option(resource = @generic_resource)
      else
        @table_option = ResourceManagerTableOption.manage_table_option(resource = @generic_resource)
      end

      # byebug

    end

    def self.set_pagination
      @pagination =
        ResourceManagerPagination.new_pagination(
          target = @sorted_resource,
          resources_per_page = @table_option.resources_per_page,
          page = @page
        )
    end

    def self.paginate_target(pagination)
      @paginated_target = Pagination::Paginate.paginate_resource(@pagination)

      @options.merge!(
        paginated_target: @paginated_target,
        has_paginated_target?: true
      )
    end

  end
end
