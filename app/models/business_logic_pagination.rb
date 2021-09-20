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

  def paginate
    @resource.offset(paginated_offeset).limit(@per_page)
  end

  def total_pages
    resource_amount = @resource.ids.count
    page_result = (resource_amount.modulo(@per_page) == 0) ? ( (resource_amount / @per_page) - 1 ) : (resource_amount / @per_page)
  end

  def display_humanized_total_pages
    total_pages + 1
  end

end
