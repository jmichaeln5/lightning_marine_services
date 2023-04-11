class Vendors::OrdersController < OrdersController
  before_action :set_vendor, only: %i[ all_orders active_orders index new create ]

  def active_orders
    # @orders = nil
    orders = @vendor.orders.unarchived
    @orders ||= resolve_orders_for_data_table(orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
  end

  def all_orders
    # @orders = nil
    orders = @vendor.orders
    @orders ||= resolve_orders_for_data_table(orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
  end

  def index
    # @orders = nil
    orders = @vendor.orders.unarchived
    @orders ||= resolve_orders_for_data_table(orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vendor
      @vendor = Vendor.includes(:orders).find(params[:vendor_id])
    end

    def set_new_order
      @order = @vendor.orders.build
      @order.build_order_content
    end

    def order_params
      params.require(:order).permit(
        :dept,
        :po_number,
        :tracking_number,
        :date_recieved,
        :courrier,
        :date_delivered,
        :purchaser_id,
        :vendor_id,
        :order_sequence,
        images: [],
        order_content_attributes: [
          :id,
          :box,
          :crate,
          :pallet,
          :other,
          :other_description
        ]
      )
    end

    def set_page_heading_title
      @page_heading_title = "Vendor Orders"
    end

end
