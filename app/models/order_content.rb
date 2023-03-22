class OrderContent < ApplicationRecord
  belongs_to :order

  validate :content_existz

  private

  def content_existz
    blank_attrs_count = 0
    blank_attrs_count +=1 if self.box.blank?
    blank_attrs_count +=1 if self.crate.blank?
    blank_attrs_count +=1 if self.pallet.blank?
    blank_attrs_count +=1 if self.other.blank?

    if blank_attrs_count >= 4
    # if blank_attrs_count >= 3
      self.order.errors.add(:order_content,  "missing" )
    end
  end

end
