class PurchasersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, only: %i[ destroy ]
  before_action :set_purchaser, only: %i[ show edit update destroy ]
  helper_method :sort_option, :sort_direction

  # # GET /purchasers or /purchasers.json
  def index
    autoload :PurchasersIndexTableSortLogic, "purchasers/sort_logic/purchasers_index_table_sort_logic.rb"
    # @purchasers = PurchasersIndexTableSortLogic.sorted_purchasers(sort_option, sort_direction)
    @sorted_purchasers = PurchasersIndexTableSortLogic.sorted_purchasers(sort_option, sort_direction)
    @purchaser = Purchaser.new

    @purchasers_per_page = 10
    @page = params.fetch(:page, 0).to_i
    @offset_arg = @page * @purchasers_per_page
    @purchasers = @sorted_purchasers.offset(@offset_arg).limit(@purchasers_per_page)

    #  For pagination btns
    @total_pages = @sorted_purchasers.length.to_i / @purchasers_per_page

  end

  # GET /purchasers/1 or /purchasers/1.json
  def show
    autoload :PurchaserShowTableSortLogic, "purchasers/sort_logic/purchaser_show_table_sort_logic.rb"
    @orders = PurchaserShowTableSortLogic.sorted_purchaser_orders(@purchaser, sort_option, sort_direction)
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

    def sort_option(sort_option = nil)
      sort_option = params[:sort_option] ||= nil
      return sort_option.to_s
    end

    def sort_direction(sort_direction = nil)
      sort_direction = params[:sort_direction] == "desc" ? "asc" : "desc"
    end
end
