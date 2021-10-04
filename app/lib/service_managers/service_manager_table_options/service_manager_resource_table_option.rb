autoload :ServiceManager, "service_managers/service_manager.rb"

module ServiceManagerResourceTableOption
  extend ServiceManager

  class ResourceHasTableOption
    def is_satisfied_by?(resource)
      !resource.user.table_options.where(resource_table_type: resource.parent_class.to_s).empty?
    end
  end

end
