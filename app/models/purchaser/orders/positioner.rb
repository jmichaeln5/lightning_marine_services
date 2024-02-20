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
    all_purchaser_orders_active = purchaser.orders.reload
     .includes(:purchaser, :vendor)
     .active.order(order_sequence: :asc)
     .select(:id, :order_sequence, :purchaser_id, :vendor_id, :created_at, :updated_at)

    new_order_sequence_position = 0
    new_order_sequence_position += 1 if (order.order_sequence == 1)

    grouped_orders = all_purchaser_orders_active.excluding(order).group_by { |purchaser_order|
      new_order_sequence_position += 1

      if new_order_sequence_position == order.order_sequence
        new_order_sequence_position += 1
        {
          id:               order.id,
          order_sequence:   order.order_sequence,
          purchaser_id:     order.purchaser_id,
          vendor_id:        order.vendor_id,
          created_at:       order.created_at,
          updated_at:       order.updated_at
        }
      else
        {
          id:               purchaser_order.id,
          order_sequence:   new_order_sequence_position,
          purchaser_id:     purchaser_order.purchaser_id,
          vendor_id:        purchaser_order.vendor_id,
          created_at:       purchaser_order.created_at,
          updated_at:       purchaser_order.updated_at
        }
      end
    }

    repositioned_order_sequence_attrs = grouped_orders.keys

    all_purchaser_orders_active.upsert_all(repositioned_order_sequence_attrs)
  end
end
