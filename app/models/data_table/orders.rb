class DataTable::Orders < DataTable
  def initialize(records = nil)
    @klass = Order
    @records = records
    @table_headers ||= %i(
      id
      position
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
    @sortable_table_headers = Order.sortable_attrs
  end
end
