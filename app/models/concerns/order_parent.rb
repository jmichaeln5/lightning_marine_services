module OrderParent
  extend ActiveSupport::Concern

  included do
    after_find do |order_parent|
      establish_order_amount
    end

    has_many :orders
    attribute :order_amount, :integer

    before_destroy :check_associated_orders
  end

  def establish_order_amount
    self.order_ids.size # ?? Forgot, is this necessary?? Doesnt look like it
    self.order_amount = self.order_ids.size
    return self.order_amount
  end

  private

    def check_associated_orders
      if self.orders.any?
        self.errors.add(:base, "Unable to delete. #{self.orders.count} associated orders. You must update associated orders before deleting.")
        throw(:abort)
      end
    end

end
