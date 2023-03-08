class Orders::BulkController < ApplicationController
  before_action :set_orders

  def destroy
    @orders.destroy_all
    redirect_to orders_path
    # redirect_back(fallback_location: orders_path, notice: "Orders successfully deleted.")
  end

  private

    def set_orders
      @orders = Order.where(id: params[:ids])
      # @orders = params[:all] ? Order.all : Order.where(id: params[:ids])
    end
end
