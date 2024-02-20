class Order::Positioning::Positioner
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

  def reposition_order_sequence!
    # update order order_sequence
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
