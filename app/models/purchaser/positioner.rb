module Purchaser::Positioner
  extend ActiveSupport::Concern

  private
    def positioner
      @positioner ||= Purchaser::Orders::Positioner.new(purchaser)
    end

    def reposition_sequenceables
      positioner.reposition_orders_order_sequence!
    end
end
