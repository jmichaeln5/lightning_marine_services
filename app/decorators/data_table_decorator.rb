class DataTableDecorator
  attr_reader :object

  def initialize(object)
    @object = object
  end

  def self.table_attrs
    %i(id order_sequence status dept ship_name vendor_name po_number date_recieved order_content courrier date_delivered)
  end

  def self.ths
    %i(id order_sequence status dept ship_name vendor_name po_number date_recieved order_content courrier date_delivered)
  end

  def self.sortable_table_headers_attrs
    Order.sortable_attrs.collect {|attr_name| attr_name.to_sym }
  end
end
