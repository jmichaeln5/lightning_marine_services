class DataTable::Orders < DataTable
  delegate :table_headers, to: :class

  delegate_missing_to :klass

  def initialize(records = nil)
    @klass = Order
    @records = records
    @sortable_table_headers = Order.sortable_attrs
  end

  def sortable_table_headers
    return @sortable_table_headers unless @sortable_table_headers.nil?

    @sortable_table_headers ||= %i(
      id
      order_sequence
      status
      courrier
      ship_name
      purchaser_name
      vendor_name
      date_recieved
      date_delivered
    )
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
