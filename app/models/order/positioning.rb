module Order::Positioning
  extend ActiveSupport::Concern

  included do
    before_validation :set_sequencer

    before_validation ->(order) {
      order.order_sequence = 1 unless order.purchaser.orders.active.exists?
      set_order_sequence_from_purchaser_positioner(order) if (order.order_sequence.blank? || order.became_active?)
    }

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
    def set_order_sequence_from_purchaser_positioner(order)
      _purchaser_positioner = order.purchaser.call_positioner
      _orders = _purchaser_positioner.orders.active.where.not(id: order.id)
      _purchaser_positioner.orders = _orders; _purchaser_positioner.set_class_attributes

      order.order_sequence = _purchaser_positioner.next_position

      _purchaser_positioner.reset_attributes!
    end

    class OrderBeforeValidaton
      attr_reader :order, :attributes

      def initialize(order)
        @order = order

        order_attributes = order.attributes.dup
        order.changes.keys.each do |key|
          order_attributes[key] = order.changes.values.first[0]
        end
        @attributes = order_attributes.freeze
      end
    end

    def set_sequencer
      @sequencer = Positioner.new(self)
      @sequencer.before_validation_attributes = OrderBeforeValidaton.new(self).attributes
    end

    def remember_to_reposition
      @sequencing = order_sequence.blank? || persisted? || previously_new_record?
    end

    def sequencing?
      @sequencing && purchaser.orders.active.exists? && !@sequencer.nil? && @sequencer.repositionable?
    end

    def reposition_sequenceables
      @sequencer.reposition_order_sequence!
      return true unless @sequencer.resposition_after_with_purchaser_positioner?

      purchaser.call_positioner.reposition_orders_order_sequence!
    end
end
