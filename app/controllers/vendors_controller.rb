class VendorsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, only: %i[ destroy ]
  before_action :set_vendor, only: %i[ show edit update destroy ]
  before_action :set_search_params, only: %i[ index show]
  before_action :set_pagination_params, only: %i[ index show ]
  helper_method :sort_option, :sort_direction

  def index
    load_resource_files

    resource_attrs = {
      called_at: Time.now,
      user: current_user,
      target: Vendor.all,
      parent_class: Vendor,
      parent_action: 'index',
      controller_name: 'vendors',
      controller_action: 'index',
      controller_name_and_action: 'vendors#index',
      search_query: @query,
      sort_option: sort_option,
      sort_direction: sort_direction,
      page: @page
    }

    @init_resource = Resource.init_resource_klass ( resource_attrs )
    @resource = Resource::ResourceKlass.get_resource
    @table_option = @resource.table_option
    @vendor = Vendor.new
    @vendors = @resource.paginated_target
  end

  # GET /vendors/1 or /vendors/1.json
  def show
    load_resource_files

    resource_attrs = {
      called_at: Time.now,
      user: current_user,
      target: @vendor.orders,
      parent_class: Vendor,
      parent_action: 'show',
      controller_name: 'vendors',
      controller_action: 'show',
      controller_name_and_action: 'vendors#show',
      search_query: @query,
      sort_option: sort_option,
      sort_direction: sort_direction,
      page: @page
    }

    @init_resource = Resource.init_resource_klass ( resource_attrs )
    @resource = Resource::ResourceKlass.get_resource

    @table_option = @resource.table_option
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

    def set_pagination_params
      # @per_page = 10
      @page = params.fetch(:page, 0).to_i
      @total_vendor_count = Vendor.all.count
    end

    def load_resource_files
      Rails.cache.clear
      autoload :ResourceManager, "resources/resource_managers/resource_manager.rb"
      autoload :Resource, "resources/resource.rb"

      Resource.reload_ivars
      ResourceManager.reload_ivars
    end

    def set_search_params
      @query = params[:q]
    end

end
