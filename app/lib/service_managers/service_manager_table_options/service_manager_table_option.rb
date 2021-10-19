module ServiceManagerTableOption

  class HasTableOption
    def is_satisfied_by?(resource)
      !resource.user.table_options.where(resource_table_type: resource.parent_class.to_s).empty?
    end
  end

end