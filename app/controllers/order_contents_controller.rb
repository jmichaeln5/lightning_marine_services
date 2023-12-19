class OrderContentsController < ApplicationController
  layout "stacked_shell"
  
  before_action :set_order_content, only: %w(show edit update destroy)

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def set_order_content
      @order_content = OrderContent.find(params[:id])
    end
end
