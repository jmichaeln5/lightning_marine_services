module Orders::Exportable
  extend ActiveSupport::Concern

  included do
    def respond_to_export_format(format, data_table: nil, filename: nil)
      filename ||= get_filename
      @orders ||= Order.all

      @data_table ||=  DataTable::Orders.new(records = @orders)

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
  end
end
