module ResourceOrders # for route - concern :orders_scoped - rename route concern to resource_orders to match
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 50 }

    before_destroy :check_associated_orders # Add Tombstone feature to represent destroyed record data instead of thorwing error?

    def self.display_name
      return "Ship" if (model_name.name == "Purchaser")
      return model_name.name
    end
  end

  def active_orders
    self.orders.where(archived: false)
  end

  def order_amount
    return self.order_ids.size unless (self.class.model_name.name == "Purchaser")
    return self.orders.active.size
  end

  private
    def check_associated_orders
      if self.orders.any?
        self.errors.add(:base, "Unable to delete. #{self.orders.count} associated orders. You must update associated orders before deleting.")
        throw(:abort)
      end
    end
end
