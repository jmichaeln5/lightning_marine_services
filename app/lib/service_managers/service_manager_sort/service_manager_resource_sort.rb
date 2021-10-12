module ServiceManagerResourceSort

  class ResourceSortDirection
    def is_satisfied_by?(resource)
        !resource.sort_option.to_s.empty?
    end
  end
end
