module Order::Positioning
  extend ActiveSupport::Concern

  included do
<<<<<<< HEAD
    before_validation ->(order) {
      order.order_sequence = 1 if order.order_sequence.blank?
    }
=======
>>>>>>> 1c3479e976eb5c63e5e85296677ff5fb28a415f6
    before_validation :set_sequencer, :set_purchaser_orders_sequencer

    after_save :remember_to_reposition
    after_commit :reposition_sequenceables, on: %i(create update), if: :sequencing?
  end

  def sequencing_attributes_names
    %w(order_sequence status date_delivered archived)
  end

  def sequencing_attributes(attributes = nil)
    return attributes.slice(*sequencing_attributes_names)
  end

  private
    def set_sequencer
      @sequencer = Positioner.new(self)
    end

    def set_purchaser_orders_sequencer
      @purchaser_orders_sequencer = Purchaser::Orders::Positioner.new(purchaser, self)
      # @purchaser_orders_sequencer = Purchaser::Orders::Positioner.new(purchaser)
    end

    def remember_to_reposition
      @sequencing = persisted? || previously_new_record?
      # @sequencing = persisted? || previously_new_record? && purchaser.orders.active.reload
      # @sequencing = persisted? || previously_new_record? && purchaser.orders.active.reorder(updated_at: :asc)
    end

    def sequencing?
      @sequencing && purchaser.orders.active.exists? && @sequencer.repositionable?
      # @sequencing && purchaser.orders.active.exists? && !@sequencer.nil? && @sequencer.repositionable?
    end

    def reposition_sequenceables
      @sequencer.reposition_order_sequence!
      @purchaser_orders_sequencer.reposition_purchaser_orders_order_sequence! if !status.in?(inactive_statuses)
    end
end
