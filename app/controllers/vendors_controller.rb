class VendorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vendor, only: %i[ show edit update destroy ]
  helper_method :sort_column, :sort_direction

  # GET /vendors or /vendors.json
  def index
    @vendor = Vendor.new
    @orders = Order.all
    if sort_column == 'id'
      @vendors = Vendor.order( sort_column + " " + sort_direction )
    elsif sort_column == 'vendor_name'
      @vendors = Vendor.reorder("name" + " " + sort_direction)
    elsif sort_column == 'order_amount'
      @most_to_least_orders = Vendor.all.sort {|a,b| b.orders.length <=> a.orders.length}

      if params[:sort_direction] == 'ASC'
        @vendors = @most_to_least_orders
      elsif params[:sort_direction] == 'DESC'
        @vendors = @most_to_least_orders.reverse
      end

    else
      @vendors = Vendor.all.order("created_at DESC")
    end

  end

  # GET /vendors/1 or /vendors/1.json
  def show
    @orders = Order.all.where(vendor_id: @vendor.id).order("created_at DESC")
    @order = Order.new
    @order_content = @order != nil ? @order.build_order_content : OrderContent.new
  end

  # GET /vendors/new
  def new
    @vendor = Vendor.new
  end

  # GET /vendors/1/edit
  def edit
  end

  # POST /vendors or /vendors.json
  def create
    @vendor = Vendor.new(vendor_params)
    if @vendor.save
      redirect_to request.referrer, notice: "Vendor created successfully."
    else
      redirect_to request.referrer
      @vendor.errors.each do |error|
        flash[:alert] = @vendor.errors.full_messages.map {|message| message}
      end
    end
  end

  # PATCH/PUT /vendors/1 or /vendors/1.json
  def update
    if @vendor.update(vendor_params)
      redirect_to request.referrer, notice: "Vendor updated successfully."
    else
      redirect_to request.referrer
      @vendor.errors.each do |error|
        flash[:alert] = @vendor.errors.full_messages.map {|message| message}
      end
    end
  end

  # DELETE /vendors/1 or /vendors/1.json
  def destroy
    if @vendor.destroy
      redirect_to orders_path, notice: "#{@vendor.name}(Vendor) deleted successfully."
    else
      redirect_to request.referrer
      @vendor.errors.full_messages.each.map {|message| flash[:alert] = message }
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vendor
      @vendor = Vendor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vendor_params
      params.require(:vendor).permit(:name)
    end

    def load_modules
      autoload :TableLogic, "table_logic.rb"
    end

    def sort_column(order_attr = nil)
      if params[:order_attr] == 'id'
        return 'id'
      elsif params[:order_attr] == 'order_amount'
        return 'order_amount'
      elsif params[:order_attr] == 'vendor_name'
        return 'vendor_name'
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
