module PackagingMaterial::Packageable
  extend ActiveSupport::Concern

  TYPES = %w[ PackagingMaterial PackagingMaterial::Box PackagingMaterial::Crate PackagingMaterial::Pallet ]

  included do
    belongs_to :order_content, inverse_of: :packaging_materials
  end
end
