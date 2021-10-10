autoload :Pagination, "services/paginations/pagination.rb"

module ResourceManagerPagination
  extend Pagination

  def self.new_pagination(resource, resources_per_page, page)
    Pagination::PaginationKlass.new(resource, resources_per_page, page)
  end

end
