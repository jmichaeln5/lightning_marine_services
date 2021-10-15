autoload :ResourceCore, "resources/resource_core.rb"
####################################################
autoload :ResourceManager, "resources/resource_managers/resource_manager.rb"
####################################################
# autoload :ServiceManagerCore, "service_managers/service_manager_core.rb"
####################################################
autoload :ServiceManager, "service_managers/service_manager.rb"
####################################################

module Resource
  extend ResourceCore
  extend ResourceManager
  # extend ServiceManagerCore
  extend ServiceManager
  # extend ResourceManagerTableOption
  # extend ResourceManagerPagination
  # extend ResourceManagerSort

  def self.init_resource_klass( options={} ) # Set ivars to be used in when called in classes below
    ResourceManager.init_resource_manager( options )
    # options.each { |k,v| instance_variable_set("@#{k}", v) }
    # byebug
    # ResourceKlass.init_resource( options ) # method extended from ResourceCore
    @init_resource ||= init_resource(options)
    @resource ||= ResourceKlass.set_resource( options ) # method defined in ResourceKlass below
    # @options ||= options

  end

      class ResourceKlass < ResourceManager::ResourceManagerKlass
          extend ResourceCore
          extend ResourceManager
          # extend ServiceManagerCore
          extend ServiceManager
          # extend ResourceManagerTableOption
          # extend ResourceManagerPagination
          # extend ResourceManagerSort
          # extend ResourceManager

          def self.set_resource( options = {} )
            # Struct.new(*options.keys).new(*options.values)
            @resource ||= Struct.new(*options.keys).new(*options.values)
            init_resource(options)
            @generic_resource ||= @resource
            @options ||= options
          end

          def self.new_resource( options = {} )
            init_resource( options )
            @resource = Struct.new(*options.keys).new(*options.values)
          end

          def self.resource_my_dood
            "Ayooooo"
            # byebug
          end

          # Setting individual service ivars
          def self.set_table_options
            super
          end

          def self.set_sort_orders_klass
            super
          end

          def self.set_pagination
            super
          end

          # Getting individual service ivars
          def self.get_table_options
            set_table_options
            @options.merge!(table_option: @table_option) # Adding table option to @options hash

            @resource_with_table_option = new_resource(@options)
            return @resource_with_table_option.table_option
          end

          def self.get_pagination
            set_pagination

            @options.merge!(pagination: @pagination)

            @resource_with_pagination = new_resource(@options)
            return @resource_with_pagination.pagination
          end

          def self.get_sort_orders_klass
            set_sort_orders_klass
          end

          def self.get_resource
            get_table_options
          end

          def self.resource_done
            puts " "
            puts "*"*500
            puts " "
            puts "   resource_done: done!    "
            puts " "
            puts "*"*500
            puts " "
            # byebug
          end

      end

end
