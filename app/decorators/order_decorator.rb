class OrderDecorator
  delegate_missing_to :order

  attr_reader :order

  def initialize(order = nil)
    @order = order
  end

  def formattable_attrs
    %i(date_recieved date_delivered)
  end

  def get_formattable_attr_value(attr)
    self.send("format_#{attr.to_sym}")
  end

  def format_date_recieved
    order.date_recieved.nil? ? nil : order.date_recieved.strftime("%m/%d/%Y")
  end

  def format_date_delivered
    order.date_delivered.nil? ? nil : order.date_delivered.strftime("%m/%d/%Y")
  end

  def return_attr_or_str(attr, str)
    attr = attr.to_sym
    attr_val = attr.in?(formattable_attrs) ? get_formattable_attr_value(attr) : order.send(attr)

    return str if attr_val.blank?
    return attr_val
  end

  def self.get_valid_status_param(status)
    return "active" if status.in?(Order::Statusable::ACTIVE_STATUS_NAMES)
    return "completed" if status.in?(Order::Statusable::INACTIVE_STATUS_NAMES)
    return "all"
  end
end
