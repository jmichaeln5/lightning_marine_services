autoload :ResourceCore, "resources/resource_core.rb"
autoload :ResourceManager, "resources/resource_managers/resource_manager.rb"
autoload :ServiceManager, "service_managers/service_manager.rb"

module Resource
  extend ResourceCore
  extend ResourceManager
  extend ServiceManager

  # Initializing ivars and structs  needed to create @resource data object
  def self.init_resource_klass( options={} )
     # Setting options hash as ivars and structs
    ResourceManager.init_resource_manager( options )
    # method extended from ResourceCore
    @init_resource = init_resource(options)
    # method defined in ResourceKlass below
    @resource = ResourceKlass.set_resource( options )
    @options = options
  end

  class ResourceKlass < ResourceManager::ResourceManagerKlass
    extend ResourceCore
    extend ResourceManager
    extend ServiceManager

    def self.set_resource( options = {} )
      @resource = Struct.new(*options.keys).new(*options.values)
      init_resource(options)
      @generic_resource = @resource  # Using @generic_resource ivar with same name in ResourceManager::ResourceManagerKlass
      @options = options
    end

    # Setting ivars for individual services from ResourceManager

    def self.set_search
      super
    end

    def self.set_sort
      super
    end

    def self.set_table_option
      super
    end

    def self.set_pagination
      super
    end

    def self.paginate_target(pagination)
      super
    end

    # Getting ivars for individual services from ResourceManager and merging into @options hash

    def self.get_search
      set_search

      @options.merge!(
        has_search_query?: true,
        target: @search_query,
        search_results: @search_query,
        results_length: @search_query.size
      )
      @generic_resource = update_resource_manager(@options)
    end

    def self.get_sort
      set_sort

      @options.merge!(
        has_sorted_target?: true,
        target: @sorted_resource
      )
      @generic_resource = update_resource_manager(@options)
    end


    def self.get_table_option
      set_table_option

      @options.merge!(
        has_table_option?: true,
        table_option: @table_option,
        resource_table_type: @table_option.resource_table_type,
        option_list: @table_option.option_list,
        selected_options: @table_option.selected_options,
        resources_per_page: @table_option.resources_per_page
      )
      @generic_resource = update_resource_manager(@options)
    end

    def self.get_pagination
      set_pagination

      @options.merge!(
        pagination: @pagination,
        has_pagination?: true,
        has_paginated_target?: false,
        total_pages: @pagination.total_pages,
        paginated_offset: @pagination.paginated_offset
      )
      @generic_resource = update_resource_manager(@options)

    end

    # Setting then Getting services ivars, merging into @options hash, returning updated resource
    def self.get_resource
      get_search
      get_sort
      get_table_option
      get_pagination
      paginate_target(@pagination)

      @generic_resource = update_resource_manager(@options)
      return @generic_resource
    end

  end
end
