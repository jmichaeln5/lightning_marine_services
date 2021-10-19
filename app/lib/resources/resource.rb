autoload :ResourceCore, "resources/resource_core.rb"
####################################################
autoload :ResourceManager, "resources/resource_managers/resource_manager.rb"
####################################################
autoload :ServiceManager, "service_managers/service_manager.rb"
####################################################

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
    def self.set_table_option
      super
    end

    def self.set_sort
      super
    end

    def self.set_pagination
      super
    end

    def self.get_resource
      set_sort
      set_table_option
      set_pagination
      return update_resource(@options)
    end
  end

end
