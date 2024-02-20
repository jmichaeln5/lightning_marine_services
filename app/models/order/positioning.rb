module Order::Positioning
  extend ActiveSupport::Concern

  included do
    before_validation ->(order) {
      order.order_sequence = 1 if order.order_sequence.blank?
    }
    before_validation :set_sequencer, :set_purchaser_orders_sequencer

    after_save :remember_to_reposition
    after_commit :reposition_sequenceables, on: [:create, :update], if: :sequencing?
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
    end

    def remember_to_reposition
      @sequencing = persisted? || previously_new_record?
    end

    def sequencing?
      @sequencing && purchaser.orders.active.exists? && @sequencer.repositionable?
    end

    def reposition_sequenceables
      @purchaser_orders_sequencer.reposition_purchaser_orders_order_sequence! if !status.in?(inactive_statuses)
      # @sequencer.reposition_order_sequence!
    end
end
