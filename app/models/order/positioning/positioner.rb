class Order::Positioning::Positioner
  class_attribute :position, default: 0

  attr_accessor :order
  attr_accessor :before_validation_attributes
  attr_accessor :resposition_after_with_purchaser_positioner

  delegate :sequencing_attributes, :sequencing_attributes_names, to: :order

  delegate_missing_to :order

  def initialize(order)
    @order = order
    @resposition_after_with_purchaser_positioner = true
  end

  def repositionable?
    return false if before_validation_attributes["id"].nil?

    return true if  (order_sequence > purchaser.orders.active.count)
    return true if order_sharing_sequence_position?
    return false if !order_sharing_sequence_position? && !attribute_differences.any?

    return true
  end

  def reposition_order_sequence!
    return insert_before_last if insert_before_last?
    return insert_after_first if insert_after_first?

    return purchaser_positioner.reposition_to_first(order: order) if reposition_to_first?
    return purchaser_positioner.reposition_to_last(order: order) if reposition_to_last?

    return swap_positions if swap_positions?

    return insert_at_lower_position if position_decreased?
    return insert_at_higher_position if position_increased?
  end

  def insert_before_last?
    no_higher_positions = (purchaser_positioner.orders_with_higher_position(order_sequence).excluding(order).count == 0)
    return !reposition_to_last? && no_higher_positions && (position_before == (order_sequence + 1))
  end

  def insert_before_last
    orders_columns = purchaser_positioner.orders.where(order_sequence: order_sequence).select(:id, :order_sequence, :purchaser_id, :vendor_id, :created_at, :updated_at)

    grouped_orders = orders_columns.group_by { |purchaser_order|
      current_position = (purchaser_order.id == id) ? order_sequence : position_before

      {
        id:               purchaser_order.id,
        order_sequence:   current_position,
        purchaser_id:     purchaser_order.purchaser_id,
        vendor_id:        purchaser_order.vendor_id,
        created_at:       purchaser_order.created_at,
        updated_at:       purchaser_order.updated_at
      }
    }
    orders_columns.upsert_all(grouped_orders.keys)
  end

  def swap_positions?
    return true if order_sequence == (position_before + 1)
    return true if order_sequence == (position_before - 1)
    return false
  end

  def swap_positions
    orders_columns = purchaser_positioner.orders.where(order_sequence: order_sequence).select(:id, :order_sequence, :purchaser_id, :vendor_id, :created_at, :updated_at)

    order_ids = orders_columns.map {|c| c.id}
    grouped_orders = orders_columns.group_by { |purchaser_order|
      current_position = (purchaser_order.id == id) ? order_sequence : position_before
      {
        id:               purchaser_order.id,
        order_sequence:   current_position,
        purchaser_id:     purchaser_order.purchaser_id,
        vendor_id:        purchaser_order.vendor_id,
        created_at:       purchaser_order.created_at,
        updated_at:       purchaser_order.updated_at
      }
    }

    Order.where(id: order_ids).select(
      :id,
      :order_sequence,
      :purchaser_id,
      :vendor_id,
      :created_at,
      :updated_at
    ).upsert_all(grouped_orders.keys)
  end

  def position_decreased?
    return false unless 'order_sequence'.in?(attribute_differences.keys)
    position_before > order_sequence
  end

  def insert_at_lower_position
    current_position = 0; self.position = order.order_sequence

    orders_columns = purchaser_positioner.orders.reload
     .includes(:purchaser, :vendor)
     .active.order(order_sequence: :asc)
     .select(:id, :order_sequence, :purchaser_id, :vendor_id, :created_at, :updated_at)

    grouped_orders = orders_columns.group_by { |purchaser_order|
      current_position += 1

      if (purchaser_order.order_sequence == order.order_sequence)
        current_position = (purchaser_order.id == order.id) ? order.order_sequence : (self.position += 1)
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

  def position_increased?
    return false unless 'order_sequence'.in?(attribute_differences.keys)
    return order_sequence > position_before
  end

  def insert_at_higher_position
    orders_columns = purchaser.orders.reload
     .includes(:purchaser, :vendor)
     .active.order(order_sequence: :asc)
     .select(:id, :order_sequence, :purchaser_id, :vendor_id, :created_at, :updated_at)

    current_position = 0; self.position = 0

    grouped_orders = orders_columns.group_by { |purchaser_order|
      current_position += 1

      if (purchaser_order.order_sequence == order.order_sequence)
        current_position = (purchaser_order.id == order.id) ? order_sequence : position_before
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

  def insert_after_first?
    no_lower_positions = (purchaser_positioner.orders_with_lower_position(order_sequence).excluding(order).count == 0)
    return_boolean = (!reposition_to_first? && no_lower_positions && (position_before == (order_sequence - 1)))
    @resposition_after_with_purchaser_positioner = !return_boolean
    return return_boolean
  end

  def insert_after_first
    orders_columns = purchaser_positioner.orders.where(order_sequence: order_sequence).select(:id, :order_sequence, :purchaser_id, :vendor_id, :created_at, :updated_at)

    order_ids = orders_columns.map {|c| c.id}
    grouped_orders = orders_columns.group_by { |purchaser_order|
      current_position = (purchaser_order.id == id) ? order_sequence : position_before
      {
        id:               purchaser_order.id,
        order_sequence:   current_position,
        purchaser_id:     purchaser_order.purchaser_id,
        vendor_id:        purchaser_order.vendor_id,
        created_at:       purchaser_order.created_at,
        updated_at:       purchaser_order.updated_at
      }
    }

    Order.where(id: order_ids).select(:id, :order_sequence, :purchaser_id, :vendor_id, :created_at, :updated_at).upsert_all(grouped_orders.keys)
  end

  def resposition_after_with_purchaser_positioner?
    @resposition_after_with_purchaser_positioner
  end

  private
    def purchaser_positioner
      @purchaser_positioner ||= purchaser.call_positioner
    end

    def attribute_differences
      differences = {}
      attributes.each { |key, value|
        differences[key] = [attributes[key], before_validation_attributes[key]] if (key.in?(sequencing_attributes_names) && (before_validation_attributes[key] != value))
      }

      return differences
    end

    def order_sharing_sequence_position?
      purchaser_positioner.orders_with_position(order_sequence).excluding(order).count > 0
    end

    def reposition_to_first?
      return true if (purchaser.orders.active.count == 0)
      return (1 >= order_sequence)
    end

    def reposition_to_last?
      return true if order_sequence > purchaser.orders.active.count
      return true if order_sequence == purchaser.orders.active.count

      return false
    end

    def position_before
      attribute_differences['order_sequence'][1]
    end
end
