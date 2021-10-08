autoload :Pagination, "services/paginations/pagination.rb"

module ResourceManagerPagination
  extend Pagination

  def self.new_pagination(resource, per_page, page)
    Pagination::PaginationKlass.new(resource, per_page, page)
  end

end
