class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[ show destroy ]
  before_action :load_modules, only: %i[ index ]
  helper_method :sort_column, :sort_direction

  # GET /orders or /orders.json
  def index
    # @orders = Order.order(params[:sort] + " " + params[:direction])
    @orders = Order.order( sort_column + " " + sort_direction )
    @order = Order.new
    @order_content = @order != nil ? @order.build_order_content : OrderContent.new
    # @purchasers = Order.joins(:purchaser).pluck(:name).sort
    # @vendors = Order.joins(:vendor).pluck(:name).sort

    # respond_to do |format|
    #   format.html
    #   format.csv do
    #     headers['Content-Disposition'] = "attachment; filename=\"orders-list\""
    #     headers['Content-Type'] ||= 'text/csv'
    #   end
    # end
    #
  end

  # GET /orders/1 or /orders/1.json
  def show
    @new_order = Order.new
    @new_order_content = @new_order != nil ? @new_order.build_order_content : OrderContent.new
  end

  # GET /orders/new
  def new
    @order = Order.new
    # @order.order_content.build
    # @order.order_content.new
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
    @order.build_order_content if @order.order_content.nil?
  end

  def create
    @order = Order.new order_params
    @order_content = @order.order_content
    # byebug
    if @order.save
      redirect_to order_path(@order), notice: "Order Created Successfully."
    else
      redirect_to request.referrer
      @order.errors.each do |error|
        flash[:alert] = @order.errors.full_messages.map {|message| message}
      end
    end
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      redirect_to request.referrer, notice: "Order Updated Successfully."
    else
      redirect_to request.referrer
      @order.errors.each do |error|
        flash[:alert] = @order.errors.full_messages.map {|message| message}
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order deleted successfully." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
      @order_content = @order.order_content
    end

    def order_params
      params.require(:order).permit(:id, :purchaser_id, :vendor_id, :dept, :po_number, :date_recieved, :courrier, :date_delivered, order_content_attributes: [ :id, :box, :crate, :pallet, :other, :other_description])
    end

    def load_modules
      autoload :TableLogic, "table_logic.rb"
    end

    def sort_column
      # params[:sort] || "id"
      Order.column_names.include?(params[:sort]) ? params[:sort] : 'id'
    end

    def sort_direction
      # params[:direction] || "desc"
      %w[desc asc].include?(params[:direction]) ? params[:direction] : 'desc'
    end

end
