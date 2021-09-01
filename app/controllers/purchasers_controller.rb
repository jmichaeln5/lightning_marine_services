class PurchasersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_purchaser, only: %i[ show edit update destroy ]
  helper_method :sort_column, :sort_direction

  # GET /purchasers or /purchasers.json
  def index
    # @purchasers = Purchaser.all.order("created_at DESC")
    @purchaser = Purchaser.new
    @orders = Order.all
    # @orders.where(purchaser_id: @purchasers.ids)

    if sort_column == 'id'
      @purchasers = Purchaser.order( sort_column + " " + sort_direction )
    elsif sort_column == 'purchaser_name'
      @purchasers = Purchaser.reorder("name" + " " + sort_direction)
    elsif sort_column == 'order_amount'
      @most_to_least_orders = Purchaser.all.sort {|a,b| b.orders.length <=> a.orders.length}

      if params[:sort_direction] == 'ASC'
        @purchasers = @most_to_least_orders
      elsif params[:sort_direction] == 'DESC'
        @purchasers = @most_to_least_orders.reverse
      end

    else
      @purchasers = Purchaser.all.order("created_at DESC")
    end
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

    def load_modules
      autoload :TableLogic, "table_logic.rb"
    end

    def sort_column(order_attr = nil)
      if params[:order_attr] == 'id'
        return 'id'
      elsif params[:order_attr] == 'order_amount'
        return 'order_amount'
      elsif params[:order_attr] == 'purchaser_name'
        return 'purchaser_name'
      end
    end

    def sort_direction
      if params[:order_attr] && params[:sort_direction] == 'DESC'
        'ASC'
      else
        "DESC"
      end
    end
end
