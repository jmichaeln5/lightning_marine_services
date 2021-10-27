module ServiceManagerSearch

  class HasSearchQuery
    def is_satisfied_by?(resource)
      !resource.search_query.nil?
    end
  end

end
