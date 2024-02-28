module Purchaser::Positioner
  extend ActiveSupport::Concern

  def call_positioner
    positioner
  end

  private
    def positioner
      @positioner ||= Purchaser::Orders::Positioner.new(self)
    end
end
