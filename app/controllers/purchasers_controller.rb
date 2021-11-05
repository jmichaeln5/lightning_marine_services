class PurchasersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, only: %i[ destroy ]
  before_action :set_purchaser, only: %i[ show edit update destroy ]
  before_action :set_search_params, only: %i[ index show]
  before_action :set_pagination_params, only: %i[ index show]
  helper_method :sort_option, :sort_direction

  # # GET /purchasers or /purchasers.json
  def index
    load_resource_files

    resource_attrs = {
      called_at: Time.now,
      user: current_user,
      target: Purchaser.all,
      parent_class: Purchaser,
      parent_action: 'index',
      controller_name: 'purchasers',
      controller_action: 'index',
      controller_name_and_action: 'purchasers#index',
      search_query: @query,
      sort_option: sort_option,
      sort_direction: sort_direction,
      page: @page
    }

    @init_resource = Resource.init_resource_klass ( resource_attrs )
    @resource = Resource::ResourceKlass.get_resource
    @table_option = @resource.table_option
    @purchaser = Purchaser.new
    @purchasers = @resource.paginated_target
  end

  # GET /purchasers/1 or /purchasers/1.json
  def show
    load_resource_files

    resource_attrs = {
      called_at: Time.now,
      user: current_user,
      target: @purchaser.orders,
      parent_class: Purchaser,
      parent_action: 'show',
      controller_name: 'purchasers',
      controller_action: 'show',
      controller_name_and_action: 'purchasers#show',
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

    def set_pagination_params
      # @per_page = 10
      @page = params.fetch(:page, 0).to_i
      @total_purchaser_count = Purchaser.all.count
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
