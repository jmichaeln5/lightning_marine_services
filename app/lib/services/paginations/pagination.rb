module Pagination

  class PaginationKlass
    attr_accessor :target, :resources_per_page, :page

    def initialize(target, resources_per_page, page)
      @target = target
      @resources_per_page = resources_per_page
      @page = page
    end

    def paginated_offset
      (@resources_per_page * @page).to_i
    end

    def paginate
      @target.offset(paginated_offset).limit(@resources_per_page)
    end

    def total_pages
      resource_amount = @target.ids.count
      page_result = (resource_amount.modulo(@resources_per_page) == 0) ? ( (resource_amount / @resources_per_page) - 1 ) : (resource_amount / @resources_per_page)
    end

    def display_humanized_total_pages
      total_pages + 1
    end
  end


  module Paginate
    def self.paginate_resource(pagination)
      # return resource.target.offset(resource.pagination.paginated_offset).limit(resource.pagination.resources_per_page)

      return pagination.target.offset(pagination.paginated_offset).limit(pagination.resources_per_page)

    end
  end


  # module Paginate
  #   return @target.offset(paginated_offset).limit(@resources_per_page)
  # end

end
