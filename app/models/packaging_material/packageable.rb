module PackagingMaterial::Packageable
  extend ActiveSupport::Concern

  TYPES = %w[ PackagingMaterial::Box PackagingMaterial::Crate PackagingMaterial::Pallet PackagingMaterial::Other ]

  HUMANIZED_TYPES = TYPES.collect { |packaging_material_type|
    packaging_material_type.safe_constantize.model_name.human
  }

  included do
    belongs_to :order_content, inverse_of: :packaging_materials
  end
end
