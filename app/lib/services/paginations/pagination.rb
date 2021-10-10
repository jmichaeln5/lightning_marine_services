module Pagination
  class PaginationKlass
    attr_accessor :resource, :resources_per_page, :page

    def initialize(resource, resources_per_page, page)
      @resource = resource
      @resources_per_page = resources_per_page
      @page = page
    end

    def paginated_offset
      (@resources_per_page * @page).to_i
    end

    def paginate
      @resource.offset(paginated_offset).limit(@resources_per_page)
    end

    def total_pages
      resource_amount = @resource.ids.count
      page_result = (resource_amount.modulo(@resources_per_page) == 0) ? ( (resource_amount / @resources_per_page) - 1 ) : (resource_amount / @resources_per_page)
    end

    def display_humanized_total_pages
      total_pages + 1
    end

  end
end
