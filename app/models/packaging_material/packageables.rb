module PackagingMaterial::Packageables
  extend ActiveSupport::Concern

  included do
    belongs_to :order_content, inverse_of: :packaging_materials

    scope :boxes, -> { where(type: 'PackagingMaterial::Box') }
    scope :crates, -> { where(type: 'PackagingMaterial::Crate') }
    scope :pallets, -> { where(type: 'PackagingMaterial::Pallet') }
    scope :others, -> { where.not(type: (PackagingMaterial::Packageable::TYPES - ["PackagingMaterial::Other"])) }
  end
end
