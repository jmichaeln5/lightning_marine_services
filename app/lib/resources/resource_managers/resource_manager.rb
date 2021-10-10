autoload :ResourceCore, "resources/resource_core.rb"
####################################################
autoload :ResourceManagerTableOption, "resources/resource_managers/resource_manager_table_options/resource_manager_table_option.rb"
####################################################
autoload :ResourceManagerPagination, "resources/resource_managers/resource_manager_paginations/resource_manager_pagination.rb"
####################################################
autoload :ResourceManagerSort, "resources/resource_managers/resource_manager_sorts/resource_manager_sort.rb"
####################################################

module ResourceManager
  extend ResourceCore
  extend ResourceManagerTableOption
  extend ResourceManagerPagination
  extend ResourceManagerSort

  def self.init_resource_manager( options={} ) # Set ivars to be used in when called in classes below
    # byebug
    options.each { |k,v| instance_variable_set("@#{k}", v) }
    # byebu
    ResourceKlass.set_resource_struct( options )
    ResourceKlass.init_resource( options ) # method extended from ResourceCore

  end

      class ResourceKlass
        extend ResourceCore
        extend ResourceManagerTableOption
        extend ResourceManagerPagination
        extend ResourceManagerSort
        extend ResourceManager

        def self.set_resource_struct( options = {} )
          @resource_klass = Struct.new(*options.keys).new(*options.values)
          init_resource(options)
        end

        def self.my_dood
          "Ayooooo"
          # byebug
        end

        def self.table_option_klass
          @table_options = ResourceManagerTableOption.new_table_option(user = @resource_klass.user, parent_class = @resource_klass.parent_class, action = @resource_klass.parent_action, page = @resource_klass.page)
        end

        def self.sort_orders_klass
          @sort_orders_klass = ResourceManagerSort.new_sort(resource = @resource_klass, target = @resource_klass.target, sort_option = @resource_klass.sort_option, sort_direction = @resource_klass.sort_direction)
        end

        def self.pagination_klass
          @pagination_klass = ResourceManagerPagination.new_pagination(resource = @resource_klass.target, resources_per_page = table_option_klass.resources_per_page, page = @page)
        end

        def self.done
          puts " "
          puts "*"*500
          puts " "
          puts "    done!    "
          puts " "
          puts "*"*500
          puts " "
          # byebug
        end

      end

end
