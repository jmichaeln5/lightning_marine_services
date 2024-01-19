# https://thoughtbot.com/blog/a-case-for-query-objects-in-rails
# https://thoughtbot.com/blog/a-case-for-query-objects-in-rails
# https://thoughtbot.com/blog/a-case-for-query-objects-in-rails
# https://thoughtbot.com/blog/a-case-for-query-objects-in-rails
# https://thoughtbot.com/blog/a-case-for-query-objects-in-rails



# ##########################################################################
# ##########################################################################
# ##########################################################################
#
# # For simplicity's sake, we are not applying a namespace to this class
# class OrderAggregator
#   def self.call(filters)
#     scope = Order.all
#
#     # if filters[:state].present?
#     #   scope = scope.where(state: filters[:state])
#     # end
#     if filters[:courrier].present?
#       scope = scope.where(courrier: filters[:courrier])
#     end
#
#     # if filters[:education_level].present?
#     #   scope = scope
#     #     .joins(:vendor)
#     #     .where(vendors: {education_level: filters[:education_level]})
#     # end
#     if filters[:vendor_name].present?
#       scope = scope
#         .includes(:vendor)
#         .references(:vendor)
#         .where('lower(name) = ?', filters[:vendor_name].downcase)
#     end
#
#     scope
#   end
# end
# ##########################################################################
# ##########################################################################
# ##########################################################################
#
# OrderAggregator.call(courrier: "DHL", vendor_name: "Hodkiewicz, Hammes and Stamm")
#
# ##########################################################################
# ##########################################################################
# ##########################################################################

# class OrderAggregator
#   class << self
#     def call(filters)
#       scope = Order.all
#       # scope = by_state(scope, filters[:state])
#       scope = by_courrier(scope, filters[:courrier])
#       # scope = by_education_level(scope, filters[:education_level])
#       scope = by_vendor_name(scope, filters[:vendor_name])
#       scope
#     end
#
#     private
#       # def by_state(scope, state)
#       #   return scope if state.blank?
#       #   scope.where(state: state)
#       # end
#       def by_courrier(scope, courrier)
#         return scope if courrier.blank?
#
#         scope.where(courrier: courrier)
#       end
#
#       # def by_education_level(scope, education_level)
#       #   return scope if education_level.blank?
#       #   scope
#       #     .joins(:vendor)
#       #     .where(vendors: {education_level: filters[:education_level]})
#       # end
#       def by_vendor_name(scope, vendor_name)
#         return scope if vendor_name.blank?
#
#         # scope.includes(:vendor).references(:vendor).where('lower(name) = ?', vendor_name.downcase)
#         scope
#           .includes(:vendor).references(:vendor)
#           # .where('lower(name) = ?', filters[:vendor_name].downcase)
#           .where('lower(name) = ?', vendor_name.downcase)
#       end
#   end
# end
##########################################################################
##########################################################################
##########################################################################
# OrderAggregator.call(courrier: "DHL")
# OrderAggregator.call(vendor_name: "Borer Inc")
#
# OrderAggregator.call(courrier: "DHL", vendor_name: "Borer Inc")

##########################################################################
##########################################################################
##########################################################################
# class OrderAggregator # FOR ORDERS DATA TABLE?
#   module Scopes
#     def by_courrier(courrier)
#       return self if courrier.blank?
#
#       where('lower(courrier) = ?', courrier.downcase)
#     end
#
#     def by_vendor_name(vendor_name)
#       return self if vendor_name.blank?
#
#       includes(:vendor).references(:vendor)
#         .where('lower(name) = ?', vendor_name.downcase)
#     end
#
#     def by_purchaser_name(purchaser_name)
#       return self if purchaser_name.blank?
#
#       includes(:purchaser).references(:purchaser)
#         .where('lower(name) = ?', purchaser_name.downcase)
#     end
#
#     def by_status(status)
#       return self if status.blank?
#
#       where(status: status)
#     end
#   end
#
#   def self.order_by(direction: :desc)
#     # debugger
#   end
#
#   def self.call(filters)
#     Order
#       .extending(Scopes)
#       .by_status(filters[:status])
#       .by_courrier(filters[:courrier])
#       .by_purchaser_name(filters[:purchaser_name])
#       .by_vendor_name(filters[:vendor_name])
#   end
# end

##########################################################################
# OrderAggregator.call(courrier: "DHL")
##########################################################################
# purchaser_name = "Stark Group"
# # purchaser_name = purchaser_name.downcase
# # OrderAggregator.call(purchaser_name: purchaser_name)
# # OrderAggregator.call(purchaser_name: purchaser_name).map &:purchaser_name
##########################################################################
# vendor_name = "Nicolas LLC"
# # vendor_name = vendor_name.downcase
# # # OrderAggregator.call(vendor_name: vendor_name)
# # # OrderAggregator.call(vendor_name: vendor_name).map &:vendor_name
##########################################################################
# OrderAggregator.call(vendor_name: "Borer Inc")
##########################################################################
# OrderAggregator.call(courrier: "DHL", vendor_name: "Borer Inc")
##########################################################################
# status = "active"
# status = "partially_delivered"
# status = "delivered"
# status = "hold"
# status = "archived"
#
# status = :active
# status = :partially_delivered
# status = :delivered
# status = :delivered
# status = :hold
#
# OrderAggregator.call(status: status)
##########################################################################
# OrderAggregator.call(status: [:hold])
# OrderAggregator.call(status: [:partially_delivered])
# OrderAggregator.call(status: [:hold, :partially_delivered])
##########################################################################
##########################################################################
##########################################################################
##########################################################################

class OrderAggregator # FOR ORDERS DATA TABLE?
  module Scopes
    def by_courrier(courrier)
      return self if courrier.blank?

      where('lower(courrier) = ?', courrier.downcase)
    end

    def by_vendor_name(vendor_name)
      return self if vendor_name.blank?

      includes(:vendor).references(:vendor)
        .where('lower(name) = ?', vendor_name.downcase)
    end

    def by_purchaser_name(purchaser_name)
      return self if purchaser_name.blank?

      includes(:purchaser).references(:purchaser)
        .where('lower(name) = ?', purchaser_name.downcase)
    end

    def by_status(status)
      return self if status.blank?

      where(status: status)
    end
  end

  # def self.order_by(direction: :desc)
  #   return self if direction.blank?
  #   # debugger
  # end

  def self.call(scope = nil, filters)
    scope ||= Order
    # Order
    scope
      .extending(Scopes)
      .by_status(filters[:status])
      .by_courrier(filters[:courrier])
      .by_purchaser_name(filters[:purchaser_name])
      .by_vendor_name(filters[:vendor_name])

      # .by_direction(filters[:direction])
  end
end
##########################################################################
##########################################################################
##########################################################################
# # OrderAggregator.call(status: [:hold])
# # OrderAggregator.call(status: [:partially_delivered])
# OrderAggregator.call(status: [:hold, :partially_delivered])
# OrderAggregator.call(status: [:hold, :partially_delivered])
# OrderAggregator.call(status: [:hold, :partially_delivered])
#
#

# purchaser = Purchaser.find(35)
# OrderAggregator.call(purchaser.orders, status: [:active])
#
# OrderAggregator.call(status: [:active])
# OrderAggregator.call(purchaser.orders, status: [:active, :partially_delivered])
#

##########################################################################

# class MarketplaceItems
#   def self.call(scope, filters)
#     new(scope).call(filters)
#   end
#
#   def initialize(scope = ServiceOffering.all)
#     @scope = scope
#   end
#
#   def call(filters = {})
#     # ...
#   end
# end


##########################################################################
##########################################################################
##########################################################################
##########################################################################
##########################################################################
##########################################################################
# params_sort = "ship_name"
# params_sort = "purchaser_name"
# params_sort = "vendor_name"
#
# orders = Order.all
# # sort_direction = "asc"
# # sort_direction = "desc"
#
# ### Order.where(id: orders.ids).filter_by_vendors(sort_dir)
#
#
# Order.where(id: orders.ids).includes(:vendor).references(:vendor).order("name" + " " + sort_direction)
# Order.where(id: orders.ids).includes(:vendor).references(:vendor).order("name" + " " + sort_direction)&:vendor_name
#
#
# ##
