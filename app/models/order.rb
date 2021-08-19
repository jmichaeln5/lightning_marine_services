class Order < ApplicationRecord
  belongs_to :purchaser
  belongs_to :vendor

  has_one :order_content

  accepts_nested_attributes_for :order_content

  validates :purchaser_id, :vendor_id, :po_number, :courrier, presence: true
  validates_associated :order_content, presence: true

  # before_update :check_attributes
  #

   # @order.check_attributes=(@order)

  def check_attributes=(attributes)

    # byebug

    params =  { self:
      {
        id: self.id,
        purchaser_id: self.purchaser_id,
        vendor_id: self.vendor_id,
        dept:self.dept,
        po_number: self.po_number,
        courrier: self.courrier,
        date_recieved: self.date_recieved,
        date_delivered: self.date_delivered,
        order_content_attributes:
          {
            id: self.order_content.id,
            order_id: self.id,
            box:  self.order_content.box,
            crate: self.order_content.crate,
            pallet: self.order_content.pallet,
            other: self.order_content.other,
            other_description: self.order_content.other_description
          }
      }
    }

    byebug
  end





end
