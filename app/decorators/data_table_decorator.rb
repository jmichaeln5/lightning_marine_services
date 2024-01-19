class DataTableDecorator
  attr_reader :object

  def initialize(object)
    @object = object
  end

  def self.table_attrs
    %i(id order_sequence status dept purchaser vendor po_number date_recieved order_content courrier date_delivered)
  end

  def self.ths
    %i(id order_sequence status dept purchaser vendor po_number date_recieved order_content courrier date_delivered)
  end

  def self.sortable_table_headers_attrs
    self.ths - %i(order_sequence dept po_number content)
  end
end
