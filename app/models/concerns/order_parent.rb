module OrderParent
  extend ActiveSupport::Concern

  included do
    has_many :orders

    before_destroy :check_associated_orders
  end

  def order_amount
    return self.order_ids.size
  end

  private

    def check_associated_orders
      if self.orders.any?
        self.errors.add(:base, "Unable to delete. #{self.orders.count} associated orders. You must update associated orders before deleting.")
        throw(:abort)
      end
    end

end
