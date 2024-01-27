module PackagingMaterial::Packageable
  extend ActiveSupport::Concern

  TYPES = %w(PackagingMaterial::Box PackagingMaterial::Crate PackagingMaterial::Pallet PackagingMaterial::Other)
  TYPE_NAMES = %w(Box Crate Pallet Other)

  included do
    attribute :type_name, :string, default: model_name.human

    belongs_to :order_content, inverse_of: :packaging_materials
  end
end
