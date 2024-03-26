class Order::Collection
  attr_reader :resource
  attr_accessor :orders

  def initialize(resource: nil, orders: nil)
    @resource = resource
    @orders = orders
  end

  def update(attribute)
    return false unless attribute.in?(attributes)
    return false if orders.blank?

    send("update_#{attribute}".to_sym)
  end

  private
    def attributes
      %w(status order_sequence)
    end

    def update_order_sequence(attribute = nil)
      updated_amount = 0
      orders.each_with_index do |order, index|
        order.order_sequence = index + 1
        updated_amount += 1 if order.save(validate: false)
      end
      return updated_amount > 0
    end

    def update_status(attribute = nil)
      delivery_date = Time.now

      orders.each_with_index do |order, index|
        order.status = "delivered"
        order.date_delivered = delivery_date
        order.archived = true
        order.save(validate: false)
      end
    end
end
