class Vendor < ApplicationRecord
  include OrderParent  #  has_many :orders
  has_many :purchasers, through: :orders

  # searchkick

  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 50 }

  # before_destroy :check_associated_orders

  # def order_count
  #   return self.order_amount = order_ids.size
  # end

  private

  # def check_associated_orders
  #   if self.orders.any?
  #     self.errors.add(:base, "Unable to delete. #{self.orders.count} associated orders. You must update the orders below to a different vendor before deleting.")
  #     throw(:abort)
  #   end
  # end

  # def search_data
  #   attributes.merge(
  #     orders: self.orders(&:orders),
  #     order_content: self.orders(&:order_content),
  #     purchasers_names: self.purchasers.map(&:name)
  #   )
  # end

end
