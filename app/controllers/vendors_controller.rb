class VendorsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, only: %i[ destroy ]
  before_action :set_vendor, only: %i[ show edit update destroy ]
  helper_method :sort_option, :sort_direction

  # GET /vendors or /vendors.json
  def index
    autoload :VenodorsIndexTableSortLogic, "vendors/sort_logic/vendors_index_table_sort_logic.rb"
    @vendors = VenodorsIndexTableSortLogic.sorted_vendors(sort_option, sort_direction)
    @vendor = Vendor.new
  end

  # GET /vendors/1 or /vendors/1.json
  def show
    autoload :VendorShowTableSortLogic, "vendors/sort_logic/vendor_show_table_sort_logic.rb"
    @orders = VendorShowTableSortLogic.sorted_vendor_orders(@vendor, sort_option, sort_direction)
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
      redirect_to dashboard_path, notice: "#{@vendor.name}(Vendor) deleted successfully."
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

    def sort_option(sort_option = nil)
      sort_option = params[:sort_option] ||= nil
      return sort_option.to_s
    end

    def sort_direction(sort_direction = nil)
      sort_direction = params[:sort_direction] == "desc" ? "asc" : "desc"
    end
end
