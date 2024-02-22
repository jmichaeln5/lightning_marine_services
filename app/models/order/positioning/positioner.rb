class Order::Positioning::Positioner
  class_attribute :position, default: 0

  attr_accessor :order
  attr_reader   :was_sequencing_attributes, :previously_was_sequencing_attributes

  delegate :sequencing_attributes, :sequencing_attributes_names, to: :order

  delegate_missing_to :order

  def initialize(order)
    @order = order
    @previously_was_sequencing_attributes = sequencing_attributes(order.attributes)
  end

  def repositionable?
    @was_sequencing_attributes = sequencing_attributes(order.attributes)

    (order_sequence_changed? || order_sequence_previously_changed?) || repositionable_by_sequencing_attribute?
  end

  def prepare_reposition
    all_purchaser_orders_active = purchaser.orders.reload
     .includes(:purchaser, :vendor)
     .active.order(order_sequence: :asc)
     .select(:id, :order_sequence, :purchaser_id, :vendor_id, :created_at, :updated_at)

    current_position = 0
    grouped_orders = all_purchaser_orders_active.excluding(order).group_by { |purchaser_order|
      current_position += 1
      current_position += 1 if (purchaser_order.order_sequence == order.order_sequence)

      {
        id:               purchaser_order.id,
        order_sequence:   current_position,
        purchaser_id:     purchaser_order.purchaser_id,
        vendor_id:        purchaser_order.vendor_id,
        created_at:       purchaser_order.created_at,
        updated_at:       purchaser_order.updated_at
      }
    }
    repositioned_order_sequence_attrs = grouped_orders.keys
    all_purchaser_orders_active.upsert_all(repositioned_order_sequence_attrs)
  end

  def reposition_order_sequence! # NOTE add method to handle first and last
    prepare_reposition

    all_purchaser_orders_active = purchaser.orders.reload
     .includes(:purchaser, :vendor)
     .active.order(order_sequence: :asc)
     .select(:id, :order_sequence, :purchaser_id, :vendor_id, :created_at, :updated_at)

    current_position = 0

    grouped_orders = all_purchaser_orders_active.group_by { |purchaser_order|
      current_position += 1

      case purchaser_order.order_sequence != order.order_sequence
      when true
        {
          id:               purchaser_order.id,
          order_sequence:   current_position,
          purchaser_id:     purchaser_order.purchaser_id,
          vendor_id:        purchaser_order.vendor_id,
          created_at:       purchaser_order.created_at,
          updated_at:       purchaser_order.updated_at
        }
      when false
        if purchaser_order.id == order.id
          {
            id:               order.id,
            order_sequence:   order.order_sequence,
            purchaser_id:     order.purchaser_id,
            vendor_id:        order.vendor_id,
            created_at:       order.created_at,
            updated_at:       order.updated_at
          }
        else
          current_position = order.order_sequence + 1
          {
            id:               purchaser_order.id,
            order_sequence:   current_position,
            purchaser_id:     purchaser_order.purchaser_id,
            vendor_id:        purchaser_order.vendor_id,
            created_at:       purchaser_order.created_at,
            updated_at:       purchaser_order.updated_at
          }
        end
      end
    }
    repositioned_order_sequence_attrs = grouped_orders.keys
    all_purchaser_orders_active.upsert_all(repositioned_order_sequence_attrs)
  end

  private
    def repositionable_by_sequencing_attribute?
      respositionable_by_previous_status? || respositionable_by_previous_archived? || respositionable_by_previous_date_delivered?
    end

    def respositionable_by_previous_status?
      previously_became_inactive? || previously_became_active?
    end

    def respositionable_by_previous_archived?
      previously_became_archived? || previously_became_unarchived?
    end

    def respositionable_by_previous_date_delivered?
      became_delivered = date_delivered_previously_was.blank? && !date_delivered_was.blank?
      became_undelivered = !date_delivered_previously_was.blank? && date_delivered_was.blank?

      became_delivered || became_undelivered
    end
end
