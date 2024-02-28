class Purchaser::Orders::Positioner
  class_attribute :position, default: 0
  class_attribute :first_position, :last_position, :next_position

  delegate_missing_to :purchaser

  attr_reader   :purchaser
  attr_accessor :orders

  def initialize(purchaser)
    @purchaser = purchaser
    @orders    = purchaser.orders.reload.active.order(order_sequence: :asc)

    set_class_attributes
  end

  def set_class_attributes
    self.first_position = 1

    position_by_index = 1
    orders.where.not(order_sequence: nil).each_with_index do |order, index|
      if order == orders.where.not(order_sequence: nil).last
        self.last_position = position_by_index
        self.next_position = position_by_index + 1
      end

      position_by_index += 1
    end
  end

  def set_orders
    self.orders = purchaser.orders.reload.active.order(order_sequence: :asc)
  end

  def reset_attributes!
    set_orders
    set_class_attributes
  end

  def position_taken_by?(order:)
    _orders = orders.active.where.not(id: order.id)
    _orders.where(order_sequence: order.order_sequence).exists?
  end

  def orders_with_position(position)
    orders.where(order_sequence: position)
  end

  def orders_with_higher_position(position)
    orders.where('order_sequence > ?', position)
  end

  def orders_with_lower_position(position)
    orders.where('order_sequence < ?', position)
  end

  def reposition_orders_order_sequence!
    orders_active_upsert_columns = orders
     .select(:id, :order_sequence, :purchaser_id, :vendor_id, :created_at, :updated_at)

    new_orders_active_upsert_column_values = orders_active_upsert_columns.group_by { |purchaser_order|
      {
        id:               purchaser_order.id,
        order_sequence:   (self.position += 1),
        purchaser_id:     purchaser_order.purchaser_id,
        vendor_id:        purchaser_order.vendor_id,
        created_at:       purchaser_order.created_at,
        updated_at:       purchaser_order.updated_at
      }
    }
    self.position = 0
    orders_active_upsert_columns.upsert_all(new_orders_active_upsert_column_values.keys)
  end

  def reposition_to_first(order:)
    orders_columns = orders.reload
     .includes(:purchaser, :vendor)
     .active.order(order_sequence: :asc)
     .select(:id, :order_sequence, :purchaser_id, :vendor_id, :created_at, :updated_at)

    current_position = 0; self.position = 1

    grouped_orders = orders_columns.group_by { |purchaser_order|
      current_position += 1

      if (purchaser_order.order_sequence == order.order_sequence)
        current_position = (purchaser_order.id == order.id) ? 1 : (self.position += 1)
      end

      {
        id:               purchaser_order.id,
        order_sequence:   current_position,
        purchaser_id:     purchaser_order.purchaser_id,
        vendor_id:        purchaser_order.vendor_id,
        created_at:       purchaser_order.created_at,
        updated_at:       purchaser_order.updated_at
      }
    }
    self.position = 0
    orders_columns.upsert_all(grouped_orders.keys)
  end

  def reposition_to_last(order:)
    orders_columns = orders.reload
     .includes(:purchaser, :vendor)
     .active.order(order_sequence: :asc)
     .select(:id, :order_sequence, :purchaser_id, :vendor_id, :created_at, :updated_at)

    current_position = 0; self.position = order.order_sequence

    grouped_orders = orders_columns.group_by { |purchaser_order|
      current_position += 1

      if (purchaser_order.order_sequence == order.order_sequence)
        current_position = (purchaser_order.id == order.id) ? order.order_sequence : (self.position -= 1)
      end

      {
        id:               purchaser_order.id,
        order_sequence:   current_position,
        purchaser_id:     purchaser_order.purchaser_id,
        vendor_id:        purchaser_order.vendor_id,
        created_at:       purchaser_order.created_at,
        updated_at:       purchaser_order.updated_at
      }
    }
    self.position = 0
    orders_columns.upsert_all(grouped_orders.keys)
  end
end
