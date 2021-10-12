module ServiceManagerResourcePagination

  class ResourcePagination
    def is_satisfied_by?(resource)
      # byebug
      # resource.user.table_options.where(resource_table_type: resource.parent_class.to_s).empty?
      return false unless resource.user.table_options.where(resource_table_type: resource.parent_class.name).present?
    end
  end

end
