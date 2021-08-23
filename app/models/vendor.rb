class Vendor < ApplicationRecord
  has_many :orders
  has_many :purchasers, through: :orders

  validates :name, presence: true, uniqueness: true

  before_destroy :check_associated_orders

  private

  def check_associated_orders
    if self.orders.any?
      self.errors.add(:base, "Unable to delete. #{self.orders.count} associated orders. You must update the orders below to a different vendor before deleting.")
      throw(:abort)
    end
  end

end
