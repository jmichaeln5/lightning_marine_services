module ServiceManagerTableOption

  class HasTableOption
    def is_satisfied_by?(resource)
      !resource.user.table_options.where(resource_table_type: resource.controller_name, resource_table_action: resource.controller_action).empty?
    end
  end

  class IsIndexAction
    def is_satisfied_by?(resource)
      resource.controller_action == 'index' ? true : false
    end
  end

  class IsShowAction
    def is_satisfied_by?(resource)
      resource.controller_action == 'show' ? true : false
    end
  end

end
