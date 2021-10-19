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

    def self.update_resource( options = {} )
      Struct.new(*options.keys).new(*options.values)
    end

    # Setting ivars for individual services from ResourceManager
    def self.set_sort
      super
    end

    def self.set_table_option
      super
    end

    def self.set_pagination
      super
    end

    # Getting ivars for individual services from ResourceManager and merging into @options hash
    def self.get_sort
      set_sort

      @options.merge!(
        target_sorted: true, uniqueness: true,
        target: @sorted_resource
      )
      @generic_resource = update_resource_manager(@options)
    end

    def self.get_table_option
      set_table_option

      @options.merge!(
        has_table_option: true,
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
        has_pagination: true,
        target: @paginated_target,
        pagination: @pagination,
        total_pages: @pagination.total_pages,
        paginated_offset: @pagination.paginated_offset
      )
      # byebug
      @generic_resource = update_resource_manager(@options)
    end

    # Setting then Getting services ivars, merging into @options hash, returning updated resource
    def self.get_resource
      get_sort
      get_table_option
      get_pagination
      return update_resource(@options)
    end
  end

end
