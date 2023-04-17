class OrderDecorator
  delegate_missing_to :@order

  def initialize(order, view_context)
    @order, @view_context = order, view_context
  end

  def purchaser_name
    @order.purchaser.name
  end

  def vendor_name
    @order.vendor.name
  end

  def eager_load_parent
    @order.includes(:purchaser, :vendor)
  end

  # private
  #
  #   def order_policy
  #     @order_policy ||= OrderPolicy.new(current_user: current_user, resource: @order)
  #   end
  #   # helper_method :order_policy


end
