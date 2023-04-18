class Purchasers::OrdersController < OrdersController

  def index
    @purchaser = Purchaser.includes(:orders).find(params[:purchaser_id])

    @orders = @purchaser.orders.unarchived
    @orders = resolve_orders_for_data_table(@orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
  end

  def all_orders
    @purchaser = Purchaser.includes(:orders).find(params[:id])

    @orders = @purchaser.orders.all
    @orders = resolve_orders_for_data_table(@orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
  end

  def completed_orders
    @purchaser = Purchaser.includes(:orders).find(params[:id])

    @orders = @purchaser.orders.archived
    @orders = resolve_orders_for_data_table(@orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_new_order
      if params[:purchaser_id]
        @purchaser = Purchaser.find(params[:purchaser_id])
      end
      @purchaser ||= Purchaser.find(params[:id])

      @order = @purchaser.orders.build
      @order.build_order_content
      @page_heading_title = "Ship: #{@purchaser.name}"
    end

end
