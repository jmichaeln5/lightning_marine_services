class Order < ApplicationRecord
  belongs_to :purchaser
  belongs_to :vendor

  has_one :order_content, dependent: :destroy

  accepts_nested_attributes_for :order_content

  validates :purchaser_id, :vendor_id, :po_number, :courrier, presence: true
  validates_associated :order_content, presence: true
end
