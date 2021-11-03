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

      if (resource_amount.modulo(@resources_per_page) == 0)
        page_result = (resource_amount / @resources_per_page)
      elsif (resource_amount.modulo(@resources_per_page) > 1 )
        page_result = (resource_amount / @resources_per_page)
      elsif (resource_amount.modulo(@resources_per_page) < 1 )
        page_result = ((resource_amount / @resources_per_page) - 1)
      end
      return page_result
    end

    def humanize_page(page_arg)
      page_arg + 1
    end

    def humanized_total_pages
      humanize_page(total_pages)
    end

    def humanized_current_page
      humanize_page(@page)
    end

    def current_page
      @page
    end

    def first_page
      0
    end

    def last_page
      total_pages
    end

    def valid_page?(page_arg)
      (page_arg >= 0 ) && ( total_pages >= page_arg )
    end

    def first_page_disabled?(page_arg = nil)
      if page_arg.nil?
        0 >= total_pages ? true : false
      else
        0 >= page_arg ? true : false
      end
    end

    def last_page_disabled?(page_arg = nil)
      if page_arg.nil?
        @page >= total_pages ? true : false
      else
        total_pages >= page_arg ? true : false
      end
    end

    def previous_page
      first_page_disabled?(@page) ? 0 : (@page - 1)
    end

    def previous_page_left
      first_page_disabled?(@page) ? 0 : (@page - 2)
    end

    def previous_page_outter_left
      first_page_disabled?(@page) ? 0 : (@page - 3)
    end

    def next_page
      last_page_disabled?(@page) ? total_pages : (@page + 1)
    end

    def next_page_right
      last_page_disabled?(@page) ? total_pages : (@page + 2)
    end

    def next_page_outter_right
      last_page_disabled?(@page) ? total_pages : (@page + 3)
    end

  end

  module Paginate
    def self.paginate_resource(pagination)
      return pagination.target.offset(pagination.paginated_offset).limit(pagination.resources_per_page)
    end
  end



end
