class Orders::BulkController < Orders::BaseController
  def update
    @orders = get_scoped_resource.orders.where(status: Order::Statusable::ACTIVE_STATUSES.keys)
    @orders.deliver_active

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.append('flashes', partial: "/layouts/stacked_shell/headings/flash_messages", locals: { flash_type: 'notice', flash_title: "Orders updated successfully." }), status: :ok
      }
      format.html         { redirect_to orders_url }
    end
  end
end
