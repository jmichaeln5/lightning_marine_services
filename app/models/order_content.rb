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
  include Packageables, PackageablesEligibility

  belongs_to :order

  validates :packaging_materials, presence: { message: "required" }, unless: -> {
    packaging_materials_error_attribute, packaging_materials_error_type = OrderValidator.packaging_materials_error_attribute, OrderValidator.packaging_materials_error_type

    !order.errors.where(packaging_materials_error_attribute, packaging_materials_error_type).any?
  }, if: :created_after_packaging_materials_implementation_date?

  def self.all_packaging_materials_attributes_pairs
    _all_packaging_materials_attributes_pair = includes(:packaging_materials).map {|_order_content| _order_content.packaging_materials_attributes_pair }
    _all_packaging_materials_attributes_pair
  end
end
