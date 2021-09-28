# class ResourcePagination ############ Before Resource Parent Class
class ResourcePagination < Resource

  attr_accessor :resource, :resources_per_page, :page

  def initialize(resource, resources_per_page, page)
    @resource = resource
    @resources_per_page = resources_per_page
    @page = page
  end

  def offset_resource_amount
    @offset_arg = @resources_per_page * @page
  end

  def paginate
    return @resource.offset(offset_resource_amount).limit(@resources_per_page) if @resource.class != Array
    # return @resource.offset(offset_resource_amount).limit(@resources_per_page)
    return @resource.drop(offset_resource_amount).first(@resources_per_page) if @resource.class == Array
  end

  def total_pages
    resource_amount = @resource.ids.count if @resource.class != Array
    resource_amount = @resource.count if @resource.class == Array

    page_result = (resource_amount.modulo(@resources_per_page) == 0) ? ( (resource_amount / @resources_per_page) - 1 ) : (resource_amount / @resources_per_page)
  end

  def display_humanized_total_pages
    total_pages.to_i + 1
  end

end
