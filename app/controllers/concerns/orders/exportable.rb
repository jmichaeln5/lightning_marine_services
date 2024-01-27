module Orders::Exportable
  extend ActiveSupport::Concern

  included do
    helper_method %i(export_formats export_params)
    helper_method %i(set_export_options_from_params)

    def set_export_options_from_params
      if params[:export]
        @export_filename = export_params.dig(:export_filename)
        @export_class, @export_ids = export_params.dig(:export_class), export_params.dig(:export_ids)
        @exportable_class, @exportable_id = export_params.dig(:exportable_class), export_params.dig(:exportable_id)
        @export_records = @export_class.safe_constantize.where(id: @export_ids)

        @options = {
          filename: @export_filename,
          export_class: @export_class,
          export_ids: @export_ids,
          exportable_class: @exportable_class,
          exportable_id: @exportable_id,
        }
      end
    end

    def export
      unless :html.in? formats
        set_export_options_from_params
      end

      respond_to do |format|
        format.xls {
          send_data @export_records,
          filename: @export_filename
        }
        format.csv {
          send_data @export_records.to_csv,
          filename: @export_filename
        }
        format.html
      end
    end

    def respond_to_do_format_exports
      respond_to do |format|
        return format.html if :html.in?(formats)

        if :xlsx.in?(formats)
          filename = export_params[:filename]
          export_class = export_params[:export_class]
          export_ids = export_params[:export_ids]

          format.xlsx {
            response.headers['Content-Disposition'] = 'attachment; filename="' + filename + '"'
          }
        end
      end
    end

    private
      def export_params
        params.require(:export).permit(:format, :filename, :exportable_class, :exportable_id, :export_class, export_ids:[], export_filters: [])
      end
  end
end
