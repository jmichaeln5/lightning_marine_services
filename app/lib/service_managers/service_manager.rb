autoload :ServiceManagerCore, "service_managers/service_manager_core.rb"

autoload :ServiceManagerResourceTableOption, "service_managers/service_manager_table_options/service_manager_resource_table_option.rb"

autoload :ServiceManagerResourcePagination, "service_managers/service_manager_pagination/service_manager_resource_pagination.rb"
autoload :ServiceManagerResourceSort, "service_managers/service_manager_sort/service_manager_resource_sort.rb"

module ServiceManager # Manages state of @resource data object with services
  extend ServiceManagerCore # Allowing Use of init_service_manager method to initialize ServiceManager Ivars
  extend ServiceManagerResourceTableOption # Manage Resource Table Option Service shizzz
  extend ServiceManagerResourcePagination #   " "
  extend ServiceManagerResourceSort #         " "

  def self.new_service_manager_struct( options = {} )
    # @service_manager = Struct.new(*options.keys).new(*options.values)
    Struct.new(*options.keys).new(*options.values)
  end

  class Composite # Specification Pattern

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


  def yeet_service_mod
    "ueet from service mod no self"
  end

end

# ### ******* Define spec as local var and pass as argument to ServiceManager::Composite.new
# ### Example- (Checking if @resource (data object) satisfys requirements for individual services):

# spec = ServiceManagerResourceTableOption::ResourceHasTableOption.new.is_satisfied_by?(@resource)
# spec.is_satisfied_by?(@resource)

# ### Example- (Checking if @resource (data object) satisfys requirements for multiple services):
# spec = ServiceManager::Composite.new(
# ServiceManagerResourceTableOption::ResourceHasTableOption)
# .and(ServiceManagerResourcePagination::ResourcePagination)
# .not(ServiceManagerResourceSort::WithSortDirection)

# spec.is_satisfied_by?(@resource)
