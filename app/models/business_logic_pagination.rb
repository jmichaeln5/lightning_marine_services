class BusinessLogicPagination

  attr_accessor :resource, :per_page, :page

  def initialize(resource, per_page, page)
    @resource = resource
    @per_page = per_page
    @page = page
  end

  def paginated_offset
    @offset_arg = @per_page * @page
  end

  def paginate
    return @resource.offset(paginated_offset).limit(@per_page) if @resource.class != Array
    # return @resource.offset(paginated_offset).limit(@per_page)
    return @resource.drop(paginated_offset).first(@per_page) if @resource.class == Array
  end

  def total_pages
    resource_amount = @resource.ids.count if @resource.class != Array
    resource_amount = @resource.count if @resource.class == Array

    page_result = (resource_amount.modulo(@per_page) == 0) ? ( (resource_amount / @per_page) - 1 ) : (resource_amount / @per_page)
  end

  def display_humanized_total_pages
    total_pages.to_i + 1
  end

end
