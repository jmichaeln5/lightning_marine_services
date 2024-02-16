class OrderDecorator
  delegate_missing_to :order

  attr_reader :order

  def initialize(order = nil)
    @order = order
  end

  def return_attr_or_str(attr, str)
    attr_val = format_attr(attr)

    return str if attr_val.blank?
    return attr_val
  end

  def self.get_status_display_name(status = nil)
    status ||= order.status
    
    return "active" if status.in?(Order.active_statuses.keys)
    return "completed" if status.in?(Order.inactive_statuses.keys)
    return "all"
  end

  private
    def formattable_attrs
      Order.attribute_names.collect {|attr| attr if Order.type_for_attribute(attr).type == :datetime }.compact_blank
    end

    def format_attr(attr)
      attr.to_s.in?(formattable_attrs) ? order.send(attr.to_sym).try(:strftime, "%m/%d/%Y") : order.send(attr.to_sym)
    end
end
