class OrderContent < ApplicationRecord
  include CastablePackageTypeFields

  belongs_to :order

  before_validation do
    set_empty_package_type_amounts_to_zero
  end

  validate :content_existz

  private
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
