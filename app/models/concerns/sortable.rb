module Sortable
  extend ActiveSupport::Concern

  module ClassMethods
    # def sort(sorting_params)
    #   results = self.where(nil)
    #
    #   sort_attrs = Hash.new
    #   sorting_params.collect {|key, value| (sort_attrs[key] = value) if key.in?(sortable_attrs)}
    #
    #   results = where(sort_attrs)
    #   results
    # end
  end
end

# sorts = Hash.new
# sorts[:status] = Array.new
# # sorts[:courrier] = Array.new
# # sorts[:order_sequence] = Array.new
# # sorts[:purchaser_name] = Array.new
# # sorts[:vendor_name] = Array.new
# # # sorts[:status].push(:active)

# @orders = Order.sort(params.slice(:status, :location, :starts_with))
# Order.sort(status: :hold)
