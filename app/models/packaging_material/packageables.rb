module PackagingMaterial::Packageables
  extend ActiveSupport::Concern

  included do
    belongs_to :order_content, inverse_of: :packaging_materials

    scope :boxes, -> { where(type: 'PackagingMaterial::Box') }
    scope :crates, -> { where(type: 'PackagingMaterial::Crate') }
    scope :pallets, -> { where(type: 'PackagingMaterial::Pallet') }
  end
end

# OrderContent.last.packaging_materials.boxes.create(description: Faker::Lorem.words(number: rand(0..5)).join(" "))
#
# OrderContent.last.packaging_materials.crates.create(description: Faker::Lorem.words(number: rand(0..5)).join(" "))
#
# OrderContent.last.packaging_materials.pallets.create(description: Faker::Lorem.words(number: rand(0..5)).join(" "))
