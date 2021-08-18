class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = Order.all.order("created_at DESC")
    @order = Order.new
    @order_content = @order != nil ? @order.build_order_content : OrderContent.new
    # order_content = OrderContent.new
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
    # @order.order_contents.build
    # @order.order_contents.new
  end

  # GET /orders/1/edit
  def edit
  end

  def create
    @order = Order.new order_params
    @order_content = params[:order][:order_content]
    if @order.save
      redirect_to request.referrer, notice: "Order Created Successfully."
    else
      redirect_to request.referrer
      @order.errors.full_messages.each.map {|message| flash[:alert] = message }
    end
  end


  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
      @order_contents = @order.order_contents
    end

    # Only allow a list of trusted parameters through.
    def order_params
      # params.require(:order).permit(:purchaser_id, :vendor_id, :dept, :po_number, :date_recieved, :courrier, :date_delivered, order_contents_attributes: [ :box, :crate, :pallet, :other, :other_description])

      # params.require(:order).permit(:purchaser_id, :vendor_id, :dept, :po_number, :date_recieved, :courrier, :date_delivered, :order_content)

      params.require(:order).permit(:purchaser_id, :vendor_id, :dept, :po_number, :date_recieved, :courrier, :date_delivered, order_content_attributes: [:order_id, :box, :crate, :pallet, :other, :other_description])
    end

    # def order_contents_params
    #   params.require(:order).permit(:purchaser_id, :vendor_id, :dept, :po_number, :date_recieved, :courrier, :date_delivered, order_contents: [:order_id, :box, :crate, :pallet, :other, :other_description])
    # end
end
