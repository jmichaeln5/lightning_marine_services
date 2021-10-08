module Pagination

  # class PaginationKlass < IndepentTableOption::TableOptionKlass
  class PaginationKlass
    attr_accessor :resource, :per_page, :page

    def initialize(resource, per_page, page)
      @resource = resource
      @per_page = per_page
      @page = page
    end

    def paginated_offset
      (@per_page * @page).to_i
    end

    def paginate
      @resource.offset(paginated_offset).limit(@per_page)
    end

    def total_pages
      resource_amount = @resource.ids.count
      page_result = (resource_amount.modulo(@per_page) == 0) ? ( (resource_amount / @per_page) - 1 ) : (resource_amount / @per_page)
    end

    def display_humanized_total_pages
      total_pages + 1
    end

  end
end
