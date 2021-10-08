module Sort
  class SortKlass

    attr_accessor :resource, :target, :sort_option, :sort_direction

    def initialize(resource, target, sort_option = nil, sort_direction = nil)
      @resource = resource
      @target = target
      @sort_option = sort_option
      @sort_direction = sort_direction
    end

    def sortable_orders_ths
      [
        'id',
        'dept',
        'courrier',
        'date_recieved',
        'date_delivered'
      ]
    end

    # byebug

    def sort_resource
      # byebug
      if (@sort_option != nil) && (@sort_direction != nil)
          if sortable_orders_ths.include? sort_option
            return @target.reorder(sort_option + " " + sort_direction)
          elsif sort_option == 'ship_name'
            return @target.includes(:purchaser).references(:purchaser).reorder("name" + " " + sort_direction)
          elsif sort_option == 'vendor_name'
            return @target.includes(:vendor).references(:vendor).reorder("name" + " " + sort_direction)
          else
            return @target
          end
      else
          return @target
      end
    end

    # ##  method output_resource used for testing in view
    # def output_resource(resource, sort_option = nil, sort_direction = nil)
    #   if (sort_option != nil) && (sort_direction != nil)
    #     sort_option ||= sort_option
    #     sort_direction ||= sort_direction
    #     @resource
    #     return " Sorting #{sort_option} by: #{sort_direction} "
    #   end
    # end

  end
end
