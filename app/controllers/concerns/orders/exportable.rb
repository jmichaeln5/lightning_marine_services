module Orders::Exportable
  extend ActiveSupport::Concern

  included do
    helper_method %i(export_formats export_params)
    helper_method %i(set_export_options_from_params)



    def export
      # if params[:export]
      #   # export_filename = export_params.dig(:export_filename)
      #   # export_class, export_ids = export_params.dig(:export_class), export_params.dig(:export_ids)
      #   #
      #   # exportable_class, exportable_id = export_params.dig(:exportable_class), export_params.dig(:exportable_id)
      #   #
      #   # options = {
      #   #   filename: export_filename,
      #   #   export_class: export_class,
      #   #   export_ids: export_ids,
      #   #   exportable_class: exportable_class,
      #   #   exportable_id: exportable_id,
      #   # }
      #
      #
      # #
      # #   respond_to do |format|
      # #     format.csv {
      # #       send_data export_class.safe_constantize.to_csv(options: options),
      # #       filename: options.dig(:filename)
      # #     }
      # #     # format.xls {
      # #     #   send_data export_class.safe_constantize.to_csv(options: options),
      # #     #   filename: options.dig(:filename)
      # #     # }
      # #   end
      #
      #   export_records = export_class.safe_constantize.where(id: export_ids)
      #
      #   respond_to do |format|
      #     format.xls {
      #       # send_data nil,
      #       # filename: filePrefix + "Orders-#{format_datetime_now_str}.xls"
      #       send_data export_records,
      #       filename: export_params.dig(:filename)
      #     }
      #   end
      # end
    end

    # def respond_to_do_format_exports
    #   respond_to do |format|
    #     return format.html if :html.in?(formats)
    #
    #     if :xlsx.in?(formats)
    #       filename = export_params[:filename]
    #       export_class = export_params[:export_class]
    #       export_ids = export_params[:export_ids]
    #
    #       format.xlsx {
    #         response.headers['Content-Disposition'] = 'attachment; filename="' + filename + '"'
    #       }
    #     endr
    #   end
    # end

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

    def respond_to_do_format_exports
      # unless :html.in? formats
      #   # debugger
      # end

      respond_to do |format|
        # format.html {
        #   render export_template_path_str
        # }

        # format.xlsx {
        #   fName = filePrefix + "_Orders-#{format_datetime_now_str}.xlsx"
        #   response.headers['Content-Disposition'] = 'attachment; filename="' + fName + '"'
        # }



        format.xls {
          send_data @export_records,
          # filename: filePrefix + "Orders-#{format_datetime_now_str}.xls"
          # send_data nil,
          filename: @export_filename
        }


        # format.csv {
        #   send_data @orders.to_csv,
        #   filename: filePrefix + "Orders-#{format_datetime_now_str}.xls"
        # }

        format.html

      end
    end


    # # https://github.com/ChileHead/lightning_marine_services/blob/1a4192dad4bfc6c02a0e3d5afab1543cd1168d46/app/controllers/purchasers_controller.rb
    # def format_xlsx(_format, export_object)
    #   _format.xlsx {
    #     filename = export_object.filename + "_Orders-#{(DateTime.now).try(:strftime,"%m/%d/%Y") }.xlsx"
    #     #response.headers['Content-Disposition'] = 'attachment; ' + filename
    #     response.headers['Content-Disposition'] = 'attachment; filename="' + filename + '"'
    #     #send_data @orders,
    #     #filename: file_prefix + "Orders-#{(DateTime.now).try(:strftime,"%m/%d/%Y") }.xlsx"
    #   }
    # end

    private
      def export_params
        params.require(:export).permit(:format, :filename, :exportable_class, :exportable_id, :export_class, export_ids:[], export_filters: [])
      end

      def export_formats
        # %w(xlsx xls csv)
        %w(xls csv)
      end
  end
end
