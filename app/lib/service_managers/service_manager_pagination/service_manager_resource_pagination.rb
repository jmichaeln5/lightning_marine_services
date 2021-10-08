autoload :ServiceManager, "service_managers/service_manager.rb"

module ServiceManagerResourcePagination
  extend ServiceManager

  class ResourcePagination
    def is_satisfied_by?(resource)
      # resource.user.table_options.where(resource_table_type: resource.parent_class.to_s).empty?
      return false unless resource.user.table_options.where(resource_table_type: resource.parent_class.to_s).present?
    end
  end

end
