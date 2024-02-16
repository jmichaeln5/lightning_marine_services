module Order::Packageables
  extend ActiveSupport::Concern

  included do
    delegate :boxes, :crates, :pallets, :others, to: :order_content

    def has_packaging_materials?
      return false if order_content.nil?
      return order_content.has_packaging_materials?
    end

    def with_packaging_materials_attributes
      _attributes = attributes.dup
      _attributes[:order_content_attributes] = order_content.with_packaging_materials_attributes unless order_content.nil?

      _attributes
    end
  end
end
