module ServiceManagerPagination

  class PaginationKlass
    def is_satisfied_by?(resource)
      return false unless resource.user.table_options.where(resource_table_type: resource.parent_class.name).present?
    end
  end

end
