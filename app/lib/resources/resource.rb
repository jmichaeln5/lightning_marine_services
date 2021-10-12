autoload :ResourceCore, "resources/resource_core.rb"
####################################################
autoload :ResourceManager, "resources/resource_managers/resource_manager.rb"
####################################################

module Resource
  extend ResourceCore
  extend ResourceManager
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
  end

      class ResourceKlass < ResourceManager::ResourceManagerKlass
        extend ResourceCore
        extend ResourceManager
        # extend ResourceManagerTableOption
        # extend ResourceManagerPagination
        # extend ResourceManagerSort
        # extend ResourceManager

        def self.set_resource( options = {} )
          # Struct.new(*options.keys).new(*options.values)
          @resource ||= Struct.new(*options.keys).new(*options.values)
          init_resource(options)
          @generic_resource = @resource
        end

        def self.resource_my_dood
          "Ayooooo"
          # byebug
        end

        def self.set_table_options
          super
        end

        def self.set_sort_orders_klass
          super
        end

        def self.set_pagination_klass
          super
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
