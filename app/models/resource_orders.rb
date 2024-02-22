module ResourceOrders
  extend ActiveSupport::Concern

  included do
    delegate :display_name, to: :class

    validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 50 }

    before_destroy :check_associated_orders

    def self.display_name
      (model_name.name == "Purchaser") ? "Ship" : model_name.name
    end
  end

  private
    def check_associated_orders
      if self.orders.any?
        self.errors.add(:base, "Unable to delete. #{self.orders.count} associated orders. You must update associated orders before deleting.")
        throw(:abort)
      end
    end
end
