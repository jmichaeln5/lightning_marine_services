class PurchasersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_purchaser, only: %i[ show edit update destroy ]

  # GET /purchasers or /purchasers.json
  def index
    @purchasers = Purchaser.all.order("created_at DESC")
    @purchaser = Purchaser.new
    @orders = Order.all
    @orders.where(purchaser_id: @purchasers.ids)
  end

  # GET /purchasers/1 or /purchasers/1.json
  def show
    @orders = Order.all.where(purchaser_id: @purchaser.id).order("created_at DESC")
    @order = Order.new
    @order_content = @order != nil ? @order.build_order_content : OrderContent.new

  end

  # GET /purchasers/new
  def new
    @purchaser = Purchaser.new
  end

  # GET /purchasers/1/edit
  def edit
  end

  def create
    @purchaser = Purchaser.new(purchaser_params)
    if @purchaser.save
      redirect_to request.referrer, notice: "Ship created successfully."
    else
      redirect_to request.referrer
      @purchaser.errors.each do |error|
        flash[:alert] = @purchaser.errors.full_messages.map {|message| message}
      end
    end
  end

  # PATCH/PUT /purchasers/1 or /purchasers/1.json
  def update
    if @purchaser.update(purchaser_params)
      redirect_to request.referrer, notice: "Ship updated successfully."
    else
      redirect_to request.referrer
      @purchaser.errors.each do |error|
        flash[:alert] = @purchaser.errors.full_messages.map {|message| message}
      end
    end
  end

  # DELETE /purchasers/1 or /purchasers/1.json
  def destroy
    if @purchaser.destroy
      redirect_to dashboard_path, notice: "#{@purchaser.name}(Ship) deleted successfully."
    else
      redirect_to request.referrer
      @purchaser.errors.full_messages.each.map {|message| flash[:alert] = message }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchaser
      @purchaser = Purchaser.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def purchaser_params
      params.require(:purchaser).permit(:name)
    end
end
