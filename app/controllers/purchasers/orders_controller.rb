class Purchasers::OrdersController < OrdersController
  before_action :set_purchaser, only: %i[ all_orders active_orders index new create ]

  def active_orders
    # @orders = nil
    orders = @purchaser.orders.unarchived
    @orders ||= resolve_orders_for_data_table(orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
  end

  def all_orders
    # @orders = nil
    orders = @purchaser.orders
    @orders ||= resolve_orders_for_data_table(orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
  end

  def index
    # @orders = nil
    orders = @purchaser.orders.unarchived
    @orders ||= resolve_orders_for_data_table(orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchaser
      @purchaser = Purchaser.includes(:orders).find(params[:purchaser_id])
    end

    def set_new_order
      @order = @purchaser.orders.build
      @order.build_order_content
    end
    
end
