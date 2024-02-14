class VendorsController < ApplicationController
  layout "stacked_shell"

  before_action :authorize_internal_user
  before_action :set_page_heading_title
  before_action :set_vendor, only: %i[edit update destroy ]

  def index
    @vendors = Vendor.includes(:orders).left_joins(:orders).group(:id).reorder("COUNT(orders.id) DESC")

    sort_vendors if params[:sort]
    @pagy, @vendors = pagy @vendors, items: params.fetch(:count, 10)
  end

  def sort_column
    %w{ id name order_amount }.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w{ asc desc }.include?(params[:direction]) ? params[:direction] : "asc"
  end

  def sort_vendors
    if params[:sort] == "order_amount"
      Vendor.left_joins(:orders).group(:id).reorder("COUNT(orders.id) #{sort_direction}")
      @vendors = nil
      vendors = Vendor.left_joins(:orders).group(:id).reorder("COUNT(orders.id) #{sort_direction}")
    else
      vendors = @vendors.reorder(sort_column => sort_direction) if %w{ id name order_amount }.include?(params[:sort])
      @vendors = nil
    end
    clear_active_record_query_cache
    @vendors = vendors
  end

  def new
    @vendor = Vendor.new
  end

  def edit
  end

  def create
    @vendor = Vendor.new(vendor_params)

    respond_to do |format|
      if @vendor.save
        format.html { redirect_to vendor_orders_path(@vendor), notice: "Vendor was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @vendor.update(vendor_params)
        format.html { redirect_to vendor_orders_path(@vendor), notice: "Vendor was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @vendor.destroy
      redirect_to vendors_url, notice: "#{@vendor.name}(Vendor) deleted successfully."
    else
      redirect_to request.referrer
      @vendor.errors.full_messages.each.map {|message| flash[:alert] = message }
    end
  end

  private
    def set_page_heading_title
      @page_heading_title = "Vendors"
    end

    def set_vendor
      @vendor = Vendor.find(params[:id])
    end

    def vendor_params
      params.require(:vendor).permit(:name)
    end
end
