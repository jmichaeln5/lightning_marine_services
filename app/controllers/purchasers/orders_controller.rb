class Purchasers::OrdersController < OrdersController
  def index
    @purchaser = Purchaser.includes(:orders).find(params[:purchaser_id])

    orders = @purchaser.orders.unarchived
    orders = orders.order(order_sequence: :asc)
    @orders = resolve_orders_for_data_table(orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_purchaser_order
  end

  def all_orders
    @purchaser = Purchaser.includes(:orders).find(params[:id])

    orders = @purchaser.orders.all
    orders = orders.order(order_sequence: :asc)
    @orders = resolve_orders_for_data_table(orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_purchaser_order
  end

  def completed_orders
    @purchaser = Purchaser.includes(:orders).find(params[:id])

    orders = @purchaser.orders.archived
    orders = orders.order(order_sequence: :asc)
    @orders = resolve_orders_for_data_table(orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_purchaser_order
  end

  def deliver_active
    @purchaser = Purchaser.includes(:orders).find(params[:purchaser_id])

    orders = @purchaser.orders.unarchived
    orders.deliver_active

    redirect_to purchaser_orders_path(@purchaser), notice: "#{@purchaser.name} active orders delivered successfully."
  end

  private
    def set_new_purchaser_order
      if params[:purchaser_id]
        @purchaser = Purchaser.find(params[:purchaser_id])
      end
      @purchaser ||= Purchaser.find(params[:id])

      @order = @purchaser.orders.build
      @order.build_order_content
      @page_heading_title = "Ship: #{@purchaser.name}"
    end
end
