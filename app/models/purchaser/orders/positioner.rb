class Purchaser::Orders::Positioner
  attr_reader   :purchaser
  attr_reader   :order # Code smell. Using :order many times throughout file, sign to move it to Order dir

  attr_accessor :orders

  def initialize(purchaser, order)
    @purchaser = purchaser
    @order     = order
    # @orders    = purchaser.orders.reload.includes(:purchaser, :vendor).active.order(order_sequence: :asc)
  end

  def reposition_purchaser_orders_order_sequence!
  end
end
