module PackagingMaterial::Packageable
  extend ActiveSupport::Concern

  TYPES = %w[ PackagingMaterial::Box PackagingMaterial::Crate PackagingMaterial::Pallet PackagingMaterial::Other ]

  HUMANIZED_TYPES = TYPES.map {|packaging_material_type| packaging_material_type.delete_prefix "PackagingMaterial::"}

  included do
    attribute :type_name, :string, default: model_name.human

    belongs_to :order_content, inverse_of: :packaging_materials
  end
end
