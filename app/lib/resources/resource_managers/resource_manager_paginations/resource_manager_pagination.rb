autoload :Pagination, "services/paginations/pagination.rb"

module ResourceManagerPagination
  extend Pagination

  def self.new_pagination(target, resources_per_page, page)
    @pagination = Pagination::PaginationKlass.new(target, resources_per_page, page)
  end

end
