autoload :ServiceManagerCore, "service_managers/service_manager_core.rb"
autoload :ServiceManagerResourceTableOption, "service_managers/service_manager_table_options/service_manager_resource_table_option.rb"
autoload :ServiceManagerResourcePagination, "service_managers/service_manager_pagination/service_manager_resource_pagination.rb"
autoload :ServiceManagerResourceSort, "service_managers/service_manager_sort/service_manager_resource_sort.rb"

module ServiceManager
  extend ServiceManagerCore # Allowing Use of init_service_manager method to initialize ServiceManager Ivars
  extend ServiceManagerResourceTableOption # Manage Resource Table Option Service shizzz
  extend ServiceManagerResourcePagination #
  extend ServiceManagerResourceSort #

  def self.new_service_manager_struct( options = {} )
    @service_manager = Struct.new(*options.keys).new(*options.values)
  end

  class Composite

    def initialize(service_managers)
      @service_managers = { truthy: Array(service_managers), falsy: [] }
    end

    def is_satisfied_by?(candidate)
      truthy_check = ->(service_manager) { service_manager.new.is_satisfied_by?(candidate) }
      falsy_check = ->(service_manager) { !service_manager.new.is_satisfied_by?(candidate) }

      @service_managers[:truthy].all?(&truthy_check) && @service_managers[:falsy].all?(&falsy_check)
    end

    def and(service_managers)
      @service_managers[:truthy] = (@service_managers[:truthy] + Array(service_managers)).uniq
      self
    end

    def not(service_managers)
      @service_managers[:falsy] = (@service_managers[:falsy] + Array(service_managers)).uniq
      self
    end

  end



  # ServiceManagerResourceTableOption::ResourceHasTableOption.new.is_satisfied_by?(resource) # Checks if Resource be sorted
  # ServiceManagerResourcePagination::ResourcePagination.new.is_satisfied_by?(resource) # Checks if Resource be sorted
  # ServiceManagerSortResource::WithSortDirection.new.is_satisfied_by?(resource) # Checks if Resource be sorted

  # def self.yeet_bruv
  #   "Yeetin"
  # end

end


# ServiceManager::ServiceManagerSortResource::WithSortDirection.new.is_satisfied_by?(@resource) # => true
