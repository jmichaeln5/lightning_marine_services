module Order::Packageables
  extend ActiveSupport::Concern

  included do
    delegate :has_packaging_materials?, to: :order_content
    delegate :boxes, :crates, :pallets, :others, to: :order_content
  end
end
