autoload :ServiceManagerCore, "service_managers/service_manager_core.rb"
autoload :ServiceManagerSortResource, "service_managers/service_manager_sort/service_manager_sort_resource.rb"


module ServiceManager
  extend ServiceManagerCore # Allowing Use of init_service_manager method to initialize ServiceManager Ivars

  def new_service_manager_struct( options = {} )
    @service_manager = Struct.new(*options.keys).new(*options.values)
  end

    module ServiceManagerSortResource
      extend ServiceManager
      class WithSortDirection
        def is_satisfied_by?(resource)
            !resource.sort_option.to_s.empty?
        end
      end
    end

    module ServiceManagerPaginateResource
      extend ServiceManager
      class WithPagination
        def is_satisfied_by?(resource)
            !resource.page.to_s.empty?
        end
      end
    end
      # module SortService
      #   extend ServiceManager
      #   # extend ServiceManagerCore
      #
      #   def self.service_set_sort
      #     return SortResource.new(resource = @parent_class, sort_option = @sort_option, sort_direction = @sort_direction, page = @page)
      #     # byebug
      #     ##     # Have Access to ivars here!!!!!! Initiated by:
      #     ##     # Have Access to ivars here!!!!!! Initiated by:
      #     ##     # Have Access to ivars here!!!!!! Initiated by:
      #     ####   @service_sort_resource_klass = ServiceManagerClass.service_set_sort.sort_resource
      #   end
      #
      #   def self.service_present_sorted_orders
      #     service_set_sort.sort_resource if service_set_sort != nil # Doesn't work without sorted params because METHOD: service_set_sort returns nil
      #
      #     # byebug
      #   end
      #
      #   def self.yeet_bruv
      #     "Yeetin"
      #   end
      #
      #   # byebug
      # end

end


# ServiceManager::ServiceManagerSortResource::WithSortDirection.new.is_satisfied_by?(@resource) # => true
