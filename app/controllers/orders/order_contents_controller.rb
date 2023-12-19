class Orders::OrderContentsController < ApplicationController
  before_action :set_order, :set_order_content, only: %i[ new create ]

  # def partial_delivery # DeliveriesController
  # end

  def new
  end

  def create
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def set_order_content
      @order_content = @order.build_order_content
    end
end
