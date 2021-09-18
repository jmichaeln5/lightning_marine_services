class BusinessLogicPagination

  attr_accessor :resource, :per_page, :page

  def initialize(resource, per_page, page)
    @resource = resource
    @per_page = per_page
    @page = page
  end

  def paginated_offeset
    @offset_arg = @per_page * @page
  end

  def paginate_index
    @resource.offset(paginated_offeset).limit(@per_page)
  end

  def total_pages
    page_result = (@resource.count.modulo(@per_page) == 0) ? ( (@resource.count / @per_page) - 1 ) : (@resource.count / @per_page)
  end

end
