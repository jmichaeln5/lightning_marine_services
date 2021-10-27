class PurchasersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, only: %i[ destroy ]
  before_action :set_purchaser, only: %i[ show edit update destroy ]
  before_action :set_search_params, only: %i[ index show]
  before_action :set_pagination_params, only: %i[ index show]
  helper_method :sort_option, :sort_direction
  # before_action :load_resource_files, only: %i[ index all_orders ] # must be after actions/methods that defines @purchasers_resource (data object) attrs in resource_attrs hash (local var)

  # # GET /purchasers or /purchasers.json
  def index
    load_resource_files

    if @query.nil?
      purchaser_target = Purchaser.all
    else
      purchaser_target = @purchasers_query
    end

    resource_attrs = {
      user: current_user,
      target: purchaser_target,
      parent_class: Purchaser,
      parent_action: 'index',
      sort_option: sort_option,
      sort_direction: sort_direction,
      page: @page
    }

    @init_resource = Resource.init_resource_klass ( resource_attrs )
    @purchasers_resource = Resource::ResourceKlass.get_resource
    @purchaser = Purchaser.new
    @purchasers = @purchasers_resource.paginated_target
  end

  # GET /purchasers/1 or /purchasers/1.json
  def show
    load_resource_files

    resource_attrs = {
      user: current_user,
      target: @purchaser.orders,
      parent_class: Purchaser,
      parent_action: 'show',
      sort_option: sort_option,
      sort_direction: sort_direction,
      page: @page
    }
    @init_resource = Resource.init_resource_klass ( resource_attrs )
    @purchaser_resource = Resource::ResourceKlass.get_resource

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
      @per_page = 10
      @page = params.fetch(:page, 0).to_i
      @total_purchaser_count = Purchaser.all.count
    end

    def load_resource_files
      autoload :ResourceManager, "resources/resource_managers/resource_manager.rb"
      autoload :Resource, "resources/resource.rb"

      Resource.reload_ivars
      ResourceManager.reload_ivars
    end

    def set_search_params
      @query = params[:q]

       if @query.present?
          Purchaser.reindex
          @search_query = Purchaser.search(@query)
          results_arr = Array.new
          @search_query.results.each do |result|
            results_arr << result.id
          end
        end

      @purchasers_query = Purchaser.where(id: results_arr)
    end

end
