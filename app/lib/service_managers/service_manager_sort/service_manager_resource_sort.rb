autoload :ServiceManager, "service_managers/service_manager.rb"

module ServiceManagerResourceSort
  extend ServiceManager

  class ResourceSortDirection
    def is_satisfied_by?(resource)
        !resource.sort_option.to_s.empty?
    end
  end
end
