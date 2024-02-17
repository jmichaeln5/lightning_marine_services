class Purchaser::Orders::Positioner
  attr_reader   :purchaser
  attr_accessor :order, :orders

  delegate :position, to: :order

  def initialize(purchaser, order = nil)
    @purchaser = purchaser
    @order = order
    @orders = purchaser.orders.active.order(order_sequence: :asc)
  end

  def reposition_purchaser_orders_order_sequence!
    # Update active orders order_sequence
  end
end
