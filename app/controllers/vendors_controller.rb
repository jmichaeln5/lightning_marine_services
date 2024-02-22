class VendorsController < ApplicationController
  layout "stacked_shell"

  before_action :authorize_internal_user
  before_action :set_page_heading_title
  before_action :set_vendor, only: %i[edit update destroy ]

  def index
    @vendors = Vendor.includes(:orders).left_joins(:orders).group(:id).reorder("COUNT(orders.id) DESC")
    @vendors = sort_resource if params[:sort]
    @pagy, @vendors = pagy @vendors, items: params.fetch(:count, 10)
  end

  def sort_resource
    sortable_scope = controller_name.classify
    controller_resource_klass = controller_name.classify.safe_constantize

    if controller_resource_klass.try(:sortable?) && controller_resource_klass.send(:sortable?)
      sort_column = controller_resource_klass.send(:sortable_attribute_names).include?(params[:sort]) ? params[:sort] : 'id'
      sort_direction = %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'

      return controller_resource_klass.send(:order_by_sortable_attribute_name, sort_column, sort_direction)
    end
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
