autoload :ServiceManagerCore, "service_managers/service_manager_core.rb"
####################################################
autoload :ServiceManagerSearch, "service_managers/service_manager_searches/service_manager_search.rb"
####################################################
autoload :ServiceManagerTableOption, "service_managers/service_manager_table_options/service_manager_table_option.rb"
####################################################
autoload :ServiceManagerPagination, "service_managers/service_manager_paginations/service_manager_pagination.rb"
####################################################
autoload :ServiceManagerSort, "service_managers/service_manager_sorts/service_manager_sort.rb"
####################################################

module ServiceManager # Manages state of @resource data object with services
  extend ServiceManagerCore # Allowing Use of init_service_manager method to initialize ServiceManager Ivars
  extend ServiceManagerTableOption # Manage Resource Table Option Service shizzz
  extend ServiceManagerPagination #   " "
  extend ServiceManagerSort #         " "

  def self.init_new_service_manager( options = {} )
    @init_service_manager ||= init_service_manager(options)
  end

  def self.set_new_service_manager( options = {} )
    @service_manager ||= Struct.new(*options.keys).new(*options.values)
    init_service_manager(options)
    @generic_service_manager ||= @service_manager
    @options ||= options
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

    # def self.yeet_composite
    #   "yeet_composite: Big yeets from Composite"
    # end

  end

  class ManageServices < Composite
    extend ServiceManagerCore
    extend ServiceManagerTableOption
    extend ServiceManagerPagination
    extend ServiceManagerSort

    def initialize(service_managers)
      super
    end

    def is_satisfied_by?(candidate)
      super
    end

    def and(service_managers)
      super
    end

    def not(service_managers)
      super
    end

    def self.yeet_manage_service
      "yeet_manage_service: Big yeets from ManageServices"
    end

    def self.manage_table_option_service(resource)
      # "yeet_manage_service: Big yeets from ManageServices"
      # spec = ServiceManager::Composite.new(
      # ServiceManagerTableOption::HasTableOption)
      # .and(ServiceManagerTableOption::IsIndexAction)
      # .and(ServiceManagerTableOption::IsShowAction)
    end

  end



end

# ### ******* Define spec as local var and pass as argument to ServiceManager::Composite.new
# ### Example- (Checking if @resource (data object) satisfys requirements for individual services):

# spec = ServiceManagerTableOption::HasTableOption.new.is_satisfied_by?(@resource)
# spec.is_satisfied_by?(@resource)

# ### Example- (Checking if @resource (data object) satisfys requirements for multiple services):
# spec = ServiceManager::Composite.new(
# ServiceManagerTableOption::HasTableOption)
# .and(ServiceManagerPagination::PaginationKlass)
# .not(ServiceManagerSort::WithSortDirection)

# spec.is_satisfied_by?(@resource)
