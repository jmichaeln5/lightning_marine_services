class Vendors::OrdersController < OrdersController
  before_action :authorize_internal_user

  def index
    @vendor = Vendor.includes(:orders).find(params[:vendor_id])

    @orders = @vendor.orders.unarchived
    @orders = resolve_orders_for_data_table(@orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
  end

  def all_orders
    @vendor = Vendor.includes(:orders).find(params[:id])

    @orders = @vendor.orders.all
    @orders = resolve_orders_for_data_table(@orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
  end

  def completed_orders
    @vendor = Vendor.includes(:orders).find(params[:id])

    @orders = @vendor.orders.archived
    @orders = resolve_orders_for_data_table(@orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_new_order
      if params[:vendor_id]
        @vendor = Vendor.find(params[:vendor_id])
      end
      @vendor ||= Vendor.find(params[:id])

      @order = @vendor.orders.build
      @order.build_order_content
      @page_heading_title = "Vendor: #{@vendor.name}"
    end

end
