# == Schema Information
#
# Table name: order_contents
#
#  id                :bigint           not null, primary key
#  box               :string
#  crate             :string
#  pallet            :string
#  other             :string
#  other_description :text
#  order_id          :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class OrderContent < ApplicationRecord
  include CastablePackageTypeFields

  belongs_to :order

  has_many :packaging_materials, dependent: :destroy
  has_many :packaging_materials_boxes, class_name: 'PackagingMaterial::Box'
  has_many :packaging_materials_crates, class_name: 'PackagingMaterial::Crate'
  has_many :packaging_materials_pallets, class_name: 'PackagingMaterial::Pallet'
  has_many :packaging_materials_others, class_name: 'PackagingMaterial::Other'

  accepts_nested_attributes_for :packaging_materials, allow_destroy: true

  # validate :content_existz

  before_validation do
    set_empty_package_type_amounts_to_zero
  end

  def packaging_materials_attrs
    [box, crate, pallet, other]
  end

  def get_packaging_materials_by_type(type:)
    return nil unless packaging_materials.any?
    return packaging_materials.where(type: "PackagingMaterial::#{type.capitalize}")
  end

  def has_packaging_material?(type:)
    return false unless packaging_materials.any?

    packaging_material_type_str = "PackagingMaterial::#{type.capitalize}"
    packaging_materials.where(type: packaging_material_type_str).any?
  end

  private
    def set_empty_package_type_amounts_to_zero
      self.box = '0' if box.nil?
      self.crate = '0' if crate.nil?
      self.pallet = '0' if pallet.nil?
    end

    def content_existz
      blank_attrs_count = 0

      blank_attrs_count +=1 if self.box.blank?
      blank_attrs_count +=1 if self.crate.blank?
      blank_attrs_count +=1 if self.pallet.blank?
      blank_attrs_count +=1 if self.other.blank?

      if blank_attrs_count >= 4
        self.order.errors.add(:order_content,  "missing" ) unless self.order.errors[:order_content].any?
      end
    end
end
