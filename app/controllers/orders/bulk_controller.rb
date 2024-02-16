class Orders::BulkController < Orders::BaseController
  before_action :set_scoped_resource

  def update
    @scoped_resource.orders.active.deliver_active

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.append('flashes', partial: "/layouts/stacked_shell/headings/flash_messages", locals: { flash_type: 'notice', flash_title: "Orders updated successfully." }), status: :ok
      }
      format.html         { redirect_to orders_url }
    end
  end
end
