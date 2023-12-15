module OrderParent
  extend ActiveSupport::Concern

  included do
    has_many :orders

    before_destroy :check_associated_orders # Add Tombstone feature to represent destroyed record data instead of thorwing error?
  end

  def active_orders
    self.orders.where(archived: false)
  end

  def order_amount # not in use + shitty, remove this method
    return self.order_ids.size unless (self.class.model_name.name == "Purchaser")
    return self.orders.unarchived.size
  end

  private
    def check_associated_orders
      if self.orders.any?
        self.errors.add(:base, "Unable to delete. #{self.orders.count} associated orders. You must update associated orders before deleting.")
        throw(:abort)
      end
    end
end
