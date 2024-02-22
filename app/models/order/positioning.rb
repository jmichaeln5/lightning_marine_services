module Order::Positioning
  extend ActiveSupport::Concern

  included do
    before_validation ->(order) {
      order.order_sequence = 1 if order.order_sequence.blank?
    }
    before_validation :set_sequencer

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

    def remember_to_reposition
      @sequencing = persisted? || previously_new_record?
    end

    def sequencing?
      @sequencing && purchaser.orders.active.exists? && !@sequencer.nil? && @sequencer.repositionable?
    end

    def reposition_sequenceables
      @sequencer.reposition_order_sequence!
    end
end
