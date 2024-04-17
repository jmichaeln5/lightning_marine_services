module Orders::Exportable
  extend ActiveSupport::Concern

  included do
    def respond_to_export_format(format, data_table: nil, filename: nil)
      filename ||= get_filename

      set_exportable_orders if @orders.nil?
      set_data_table
      set_table_headers

      format.csv {
        send_data @data_table.records.to_csv,
        filename: "#{filename}.#{filename_ext}"
      }
      format.xls {
        send_data @data_table.records.to_csv,
        filename: "#{filename}.#{filename_ext}"
      }
      format.xlsx {
        filename = "#{filename}.xlsx"
        response.headers['Content-Disposition'] = 'attachment; filename="' + filename + '"'
      }
    end

    private
      def export_params
        params.permit(
         :format, :filename, :resource_scope_name, :resource_scope_id, :purchaser_id, :vendor_id, :status,
         statuses: [], columns: [],
         )
      end

      def format_export?
        (:html.in?(formats)) ? false : true
      end

      def filename_ext
        request.format.symbol.to_s
      end

      def get_filename(status: nil, scoped_resource: nil)
        timestamp = "#{(DateTime.now).try(:strftime,"%m/%d/%Y") }"; timestamp = timestamp.gsub("/", "-")
        _filename = ""
        _filename << "#{scoped_resource.name} " unless scoped_resource.nil?
        _filename << "#{status} " unless status.nil?
        _filename << "orders #{timestamp}"
        _filename = _filename.gsub("-", "_"); _filename = _filename.gsub(" ", "_")

        return _filename
      end

      def set_exportable_orders
        @orders = Order.all
      end

      def set_data_table
        @data_table = DataTable::Orders.new(records = @orders)
      end

      # def set_table_headers
      #   table_headers = %i(order_sequence dept ship_name vendor_name po_number date_recieved boxes crates pallets courrier)
      #
      #   return (@table_headers = table_headers) if @scoped_resource.nil?
      #
      #   scoped_resource_name = @scoped_resource.nil? ? nil : @scoped_resource.model_name.singular
      #
      #   case scoped_resource_name
      #   when 'vendor'
      #     table_headers = %i(order_sequence dept ship_name po_number date_recieved boxes crates pallets courrier)
      #   when 'purchaser'
      #     table_headers = %i(order_sequence dept vendor_name po_number date_recieved boxes crates pallets courrier)
      #   when 'ship'
      #     table_headers = %i(order_sequence dept vendor_name po_number date_recieved boxes crates pallets courrier)
      #   end
      #
      #   @table_headers = table_headers
      # end

      def set_table_headers
        _status_param = params.dig(:status)

        table_headers = %i(order_sequence status dept ship_name vendor_name po_number date_recieved boxes crates pallets courrier date_delivered)

        table_headers.delete(:status)         if (_status_param == 'completed')
        table_headers.delete(:status)         if (_status_param == 'active')
        table_headers.delete(:date_delivered) if (_status_param == 'active')

        scoped_resource_name = @scoped_resource.nil? ? nil : @scoped_resource.model_name.singular

        table_headers.delete(:ship_name)      if scoped_resource_name == "purchaser"
        table_headers.delete(:vendor_name)    if scoped_resource_name == "vendor"

        @table_headers = table_headers
      end
  end
end
