# autoload :ServiceManagerResourceTableOption, "service_managers/service_manager_table_options/service_manager_resource_table_option.rb"
# autoload :ServiceManagerResourcePagination, "service_managers/service_manager_pagination/service_manager_resource_pagination.rb"
# autoload :ServiceManagerResourceSort, "service_managers/service_manager_sort/service_manager_resource_sort.rb"


module ServiceManagerCore
  # extend ServiceManagerResourceTableOption # Manage Resource Table Option Service shizzz
  # extend ServiceManagerResourcePagination #
  # extend ServiceManagerResourceSort #

  def init_service_manager( options={} ) # Set ivars to be used in when called in classes below
    options.each { |k,v| instance_variable_set("@#{k}", v) }
  end

end
