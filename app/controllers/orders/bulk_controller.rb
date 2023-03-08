class Orders::BulkController < ApplicationController
  before_action :set_orders

  def destroy
    order_count = @orders.count
    @orders.destroy_all
    notice_message = "#{order_count} orders deleted successfully." if order_count > 1
    notice_message =  "Order successfully deleted." if !(order_count > 1)
    redirect_back(fallback_location: orders_path, notice: notice_message)
  end

  private

    def set_orders
      # @orders = Order.where(id: params[:ids])
      @orders = params[:all] ? Order.all : Order.where(id: params[:ids])
    end
end
