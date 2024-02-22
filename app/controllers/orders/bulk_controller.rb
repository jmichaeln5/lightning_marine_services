class Orders::BulkController < Orders::BaseController
  before_action :authorize_internal_user, :set_scoped_resource, :set_orders

  def update
    (@flash_type, @flash_title = 'warning', 'Nothing to update') if @collection.orders.blank?
    (@flash_type, @flash_title = 'notice', 'Orders updated successfully.') if @collection.update(attribute)

    @flash_type ||= 'alert'
    @flash_title ||= "Error: could not update"

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.append('flashes',
          partial: "/layouts/stacked_shell/headings/flash_messages", locals: {
            flash_type: @flash_type,
            flash_title: @flash_title,
          }), status: :ok
      }
      format.html         { redirect_to orders_url }
    end
  end

  private
    def order_params
      params.permit(:attribute, :status)
    end

    def updatable_attributes
      %w(status order_sequence)
    end

    def attribute
      _attribute = order_params[:attribute]
      _attribute.in?(updatable_attributes) ? _attribute : nil
    end

    def set_orders
      @collection = Order::Collection.new(resource: @scoped_resource, orders: @scoped_resource.orders.active)
    end
end
