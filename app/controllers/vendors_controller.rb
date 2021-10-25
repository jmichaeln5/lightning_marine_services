class VendorsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, only: %i[ destroy ]
  before_action :set_vendor, only: %i[ show edit update destroy ]
  before_action :set_search_params, only: %i[ index all_orders show]
  before_action :set_pagination_params, only: %i[ index show ]
  helper_method :sort_option, :sort_direction
  # before_action :load_resource_files, only: %i[ index show ] # must be after actions/methods that defines @resource (data object) attrs in resource_attrs hash (local var)

  def index
    load_resource_files

    if @query.nil?
      vendors_target = Vendor.all
    else
      vendors_target = @vendors_query
    end

    resource_attrs = {
      user: current_user,
      target: vendors_target,
      parent_class: Vendor,
      parent_action: 'index',
      sort_option: sort_option,
      sort_direction: sort_direction,
      page: @page
    }

    @init_resource = Resource.init_resource_klass ( resource_attrs )
    @resource = Resource::ResourceKlass.get_resource
    @vendor = Vendor.new
    # @vendors = @resource.target
    @vendors = @resource.paginated_target

    # if @resource.parent_class != Vendor
    #   byebug
    # end

    # byebug
  end


  ####################################################
  ####################################################
  ####################################################
  # # GET /vendors/1 or /vendors/1.json
  # def show
  #   autoload :VendorShowTableSortLogic, "vendors/sort_logic/vendor_show_table_sort_logic.rb"
  #   @sorted_vendor_orders = VendorShowTableSortLogic.sorted_vendor_orders(@vendor, sort_option, sort_direction)
  #   @order = Order.new
  #   @order_content = @order != nil ? @order.build_order_content : OrderContent.new
  #   @orders = BusinessLogicPagination.new(@sorted_vendor_orders, 10, @page)
  #   @initialize_table_options = BusinessLogicTableOption.new(current_user, 'Vendor')
  # end

  # GET /vendors/1 or /vendors/1.json
  def show
    # autoload :VendorShowTableSortLogic, "vendors/sort_logic/vendor_show_table_sort_logic.rb"
    # @sorted_vendor_orders = VendorShowTableSortLogic.sorted_vendor_orders(@vendor, sort_option, sort_direction)
    # @order = Order.new
    # @order_content = @order != nil ? @order.build_order_content : OrderContent.new
    # @orders = BusinessLogicPagination.new(@sorted_vendor_orders, 10, @page)
    # @initialize_table_options = BusinessLogicTableOption.new(current_user, 'Vendor')

    load_resource_files

    if @query.nil?
      vendors_target = @vendor.orders
    else
      vendors_target = @vendors_query
    end

    resource_attrs = {
      user: current_user,
      target: vendors_target,
      parent_class: Vendor,
      parent_action: 'show',
      sort_option: sort_option,
      sort_direction: sort_direction,
      page: @page
    }

    @init_resource = Resource.init_resource_klass ( resource_attrs )
    @resource = Resource::ResourceKlass.get_resource
    @order = Order.new
    @order_content = @order != nil ? @order.build_order_content : OrderContent.new
  end
  ####################################################
  ####################################################
  ####################################################






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
      @page = params.fetch(:page, 0).to_i
    end

    def load_resource_files
      autoload :ResourceManager, "resources/resource_managers/resource_manager.rb"
      autoload :Resource, "resources/resource.rb"

      # Resource.reload_ivars
      # ResourceManager.reload_ivars
    end

    def set_search_params
      @query = params[:q]

       if @query.present?
          Vendor.reindex
          raw_query = Vendor.search(@query)
          results_arr = Array.new
          raw_query.results.each do |result|
            results_arr << result.id
          end
        end

      @vendors_query = Vendor.where(id: results_arr)
    end

end
