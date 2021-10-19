autoload :Pagination, "services/paginations/pagination.rb"

module ResourceManagerPagination
  extend Pagination

  def self.new_pagination(target, resources_per_page, page)
    Pagination::PaginationKlass.new(target, resources_per_page, page)
  end

  def self.paginate_resource(target, paginated_offset, resources_per_page)
    target.offset(paginated_offset).limit(resources_per_page)
  end

end
