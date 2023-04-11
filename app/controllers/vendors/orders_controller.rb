class Vendors::OrdersController < OrdersController
  before_action :set_page_heading_title
  before_action :set_vendor, only: %i[ index new create ]
  before_action :set_orders, only: %i[ index ]

  def index
    @orders = nil
    orders = @vendor.orders

    @orders ||= resolve_orders_for_data_table(orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
  end

  # def new
  #   set_new_order
  # end
  #
  # def create
  #   @order = Order.new(order_params)
  #
  #   respond_to do |format|
  #     if @order.save
  #       # format.html { redirect_to vendor_order_url(@vendor_order), notice: "Order was successfully created." }
  #       format.html { redirect_to @order, notice: "Order was successfully created." }
  #       format.json { render :show, status: :created, location: @order }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @order.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vendor
      @vendor = Vendor.includes(:orders).find(params[:vendor_id])
    end

    def set_orders
      @orders = @vendor.orders
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
