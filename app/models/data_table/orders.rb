class DataTable::Orders < DataTable
  delegate :table_headers, to: :class

  delegate_missing_to :klass

  def initialize(records = nil)
    @klass, @records = Order, records
    @records ||= Order.includes(:order_content, :packaging_materials, :purchaser, :vendor)
    @sortable_table_headers = Order.sortable_attrs
  end

  def order_attribute_names
    Order.attribute_names
  end

  def order_non_attribute_names
    %w(boxes crates pallets others)
  end

  def self.table_headers
    @table_headers ||= %i(
      id
      order_sequence
      status
      dept
      ship_name
      vendor_name
      po_number
      date_recieved
      order_content
      courrier
      date_delivered
    )
  end
end
