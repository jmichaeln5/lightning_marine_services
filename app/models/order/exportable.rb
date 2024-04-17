module Order::Exportable
  extend ActiveSupport::Concern

  included do
    def self.to_csv
      data_table = DataTable::Orders.new(all)
      orders = data_table.records
      table_headers = %i(order_sequence dept ship_name vendor_name po_number date_recieved boxes crates pallets courrier)

      CSV.generate do |csv|
        csv << table_headers.collect {|th| th.to_s.humanize }.freeze
        orders.each do |order|
          csv << DataTable::Orders.format_row(order: order, table_headers: table_headers).values
        end
      end
    end
  end
end
