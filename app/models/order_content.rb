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
  include Packageables

  belongs_to :order

  validates :packaging_materials, presence: { message: "required" }, unless: :has_packaging_materials?
end
