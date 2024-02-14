module Order::Packageables
  extend ActiveSupport::Concern

  included do
    delegate :has_packaging_materials?, to: :order_content
    delegate :boxes, :crates, :pallets, :others, to: :order_content

    def with_packaging_materials_attributes
      _attributes = attributes.dup
      _attributes[:order_content_attributes] = order_content.with_packaging_materials_attributes

      _attributes
    end
  end
end
