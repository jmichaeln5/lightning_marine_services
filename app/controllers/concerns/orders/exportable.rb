module Orders::Exportable
  extend ActiveSupport::Concern

  included do
    def set_ivars_from_export_params
      export_params.compact_blank!
      @filename = export_params[:filename] if export_params[:filename]
      @columns = export_params[:columns].compact_blank! if export_params[:columns]
      @filters = export_params[:filters].compact_blank! if export_params[:filters]

      @purchaser_id, @vendor_id = export_params[:purchaser_id], export_params[:vendor_id]
      @resource_scope_name, @resource_scope_id = export_params[:resource_scope_name], export_params[:resource_scope_id]

      statuses = export_params[:statuses].compact_blank! if export_params[:statuses]
      scoped_statuses = Array.new
      statuses.map {|status| scoped_statuses.push(status) if status.in?(Order.status_names)}

      if !@resource_scope_name.nil? and !@resource_scope_id.nil?
        resource = @resource_scope_name.safe_constantize.find(@resource_scope_id)
        orders = (scoped_statuses.size > 0) ? resource.orders.where(status: scoped_statuses) : resource.orders
      else
        orders = (scoped_statuses.size > 0) ? Order.where(status: scoped_statuses) : Order.all
      end
      @export_records = orders

      @options = {
        orders: @orders,
        filename: @filename,
        columns: @columns,
      }
    end

    def set_ivars_from_export_params?
      @options.nil? && !params[:export].blank?
    end

    def export
      format_export if format_export?
    end

    def format_export?
      (:html.in?(formats)) ? false : true
    end

    def format_export
      set_ivars_from_export_params if set_ivars_from_export_params?

      respond_to do |format|
        format.xls {
          response.headers['Content-Disposition'] = 'attachment; filename="' + "#{@filename}.xls" + '"'
        }
        format.xlsx {
          response.headers['Content-Disposition'] = 'attachment; filename="' + "#{@filename}.xlsx" + '"'
        }
        format.csv {
          send_data @export_records.to_csv(options: @options),
          filename: "#{@filename}.csv"
        }
      end
    end

    private
      def export_params
        params.require(:export).permit(
          :format,
          :filename,
          :resource_scope_name,
          :resource_scope_id,
          :purchaser_id,
          :vendor_id,
          :status,
          statuses: [],
          columns: [],
        )
      end
  end
end
