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
    ResourceManager.init_resource_manager( options ) # method extended from ResourceCore
    @init_resource = init_resource(options) # method defined in ResourceKlass below
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
      @options.merge!(
        has_search_query?: true,
        target: @search_query,
        search_results: @search_query,
        results_length: @search_query.size
      )
      @generic_resource = update_resource_manager(@options)
    end

    def self.set_sort
      super
      @options.merge!(
        has_sorted_target?: true,
        target: @sorted_resource
      )
      @generic_resource = update_resource_manager(@options)
    end

    def self.set_table_option
      super
      @options.merge!(
        has_table_option?: true,
        table_option: @table_option,
        resource_table_type: @table_option.resource_table_type,
        resource_table_action: @table_option.resource_table_action,
        option_list: @table_option.option_list,
        selected_options: @table_option.selected_options,
        resources_per_page: @table_option.resources_per_page
      )
      @generic_resource = update_resource_manager(@options)
    end

    def self.set_pagination
      super
      @options.merge!(
        pagination: @pagination,
        has_pagination?: true,
        has_paginated_target?: false,
        total_pages: @pagination.total_pages,
        current_page: @pagination.current_page,
        paginated_offset: @pagination.paginated_offset,
        humanized_total_pages: @pagination.humanized_total_pages,
        humanized_current_page: @pagination.humanized_current_page,
        first_page: @pagination.first_page,
        last_page: @pagination.last_page,
        first_page_disabled?: @pagination.first_page_disabled?,
        last_page_disabled?: @pagination.last_page_disabled?,
        next_page: @pagination.next_page,
        previous_page: @pagination.previous_page
      )
      @generic_resource = update_resource_manager(@options)
    end

    def self.paginate_target(pagination)
      super
    end

    def self.get_resource

      # TODO create composite where @generic_resource satisfies services in truthy arr then run truthy services

      set_search
      set_sort
      set_table_option
      set_pagination

      paginate_target(@pagination)

      @options.merge!(
        returned_at: Time.now
      )

      @generic_resource = update_resource_manager(@options)
      @resource = @generic_resource
      # returning ____@resource____
      return update_resource_manager(@options)
    end

  end
end
