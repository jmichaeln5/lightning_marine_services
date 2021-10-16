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
    ResourceManager.init_resource_manager( options ) # Setting options hash as ivars and structs
    @init_resource = init_resource(options) # method extended from ResourceCore
    @resource = ResourceKlass.set_resource( options ) # method defined in ResourceKlass below
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

# ###    TODO change name of methods to more accurately describe functionality
# ###    TODO change name of methods to more accurately describe functionality
# ###    TODO change name of methods to more accurately describe functionality
# ###    ex) 'get_table_option' => merge_table_option_into_option_hash )

      # Getting individual services and merging into @options (hash)
      def self.get_table_option
        set_table_option
        return @options.merge!(table_option: @table_option, has_table_option: true) # Adding table option to @options hash
        update_resource(@options)
      end

      def self.get_pagination
        set_pagination
        return @options.merge!(pagination: @pagination, has_pagination: true)
        update_resource(@options)
      end

      def self.get_sort_klass
        set_sort
        return @options.merge!(target: @sorted_resource, has_target: true)
        update_resource(@options)
      end

      def self.get_resource
        get_table_option
        get_pagination
        get_sort_klass
        return update_resource(@options)
      end
  end

end
