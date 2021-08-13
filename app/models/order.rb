class Order < ApplicationRecord
  belongs_to :purchaser
  belongs_to :vendor

  has_many :order_contents
  accepts_nested_attributes_for :order_contents

  validates_associated :order_contents, presence: true


  # def order_contents_attributes=(attribs)
  #   # self.order_contents = Detail.find(attribs[:box])
  #   self.order_contents = Detail.find(attribs[:box, :crate, :pallet, :other, :other_description])
  # end

  # def order_order_contents
  #   Detail.all.where(order_id: self.id)
  # end
end
