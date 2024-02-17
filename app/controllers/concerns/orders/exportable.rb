module Orders::Exportable
  extend ActiveSupport::Concern

  included do
    def format_export?
      (:html.in?(formats)) ? false : true
    end

    # def default_file_name
    #
    # end


    private
      def export_params
        params.permit(
         :format, :filename, :resource_scope_name, :resource_scope_id, :purchaser_id, :vendor_id, :status,
         statuses: [], columns: [],
         )
      end

      # def export_params
      #   params.permit(
      #   # params.require(:export).permit( :format,
      #     :filename,
      #     :resource_scope_name,
      #     :resource_scope_id,
      #     :purchaser_id,
      #     :vendor_id,
      #     :status,
      #     statuses: [],
      #     columns: [],
      #   )
      # end
  end
end
