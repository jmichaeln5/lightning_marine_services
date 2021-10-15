class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, only: %i[ destroy ]
  before_action :set_order, only: %i[ show destroy ]
  before_action :set_pagination_params, only: %i[ index all_orders ]
  helper_method :sort_option, :sort_direction

  def all_orders
    autoload :OrdersSortTableLogic, "orders/sort_logic/orders_sort_table_logic.rb"
    @sorted_orders = OrdersSortTableLogic.sorted_orders(sort_option, sort_direction)
    @orders = BusinessLogicPagination.new(@sorted_orders, @per_page, @page)
    @initialize_table_options = BusinessLogicTableOption.new(current_user, 'Order')

    @order = Order.new
    @order_content = @order != nil ? @order.build_order_content : OrderContent.new

  end

  def index
    ############ Before
    # autoload :OrdersSortTableLogic, "orders/sort_logic/orders_sort_table_logic.rb"
    # @order = Order.new
    # @order_content = @order != nil ? @order.build_order_content : OrderContent.new
    # @sorted_orders = OrdersSortTableLogic.sorted_orders(sort_option, sort_direction)
    # @orders = BusinessLogicPagination.new(@sorted_orders.unarchived, @per_page, @page)
    # @initialize_table_options = BusinessLogicTableOption.new(current_user, 'Order')

    ############ After
    ####################################################
    #### ********** For ResourceManager **********
    #### ********** For ResourceManager **********
    #### ********** For ResourceManager **********
    #### ********** For ResourceManager **********
    autoload :ResourceManager, "resources/resource_managers/resource_manager.rb"
    ####################################################
    autoload :Resource, "resources/resource.rb"
    ####################################################


    klass_attrs = {
     user: User.first,
     target: Order.all,
     parent_class: Order,
     parent_action: 'index',
     sort_option: sort_option,
     sort_direction: sort_direction,
     page: @page
   }

   # @init_resource_manager = ResourceManager.init_resource_manager ( klass_attrs ) # Resource Data Object
   @init_resource = Resource.init_resource_klass ( klass_attrs )


   @resource = Resource.init_resource_klass ( klass_attrs )

   # @resource = Resource::ResourceKlass.new_resource_struct( klass_attrs )
   # Resource::ResourceKlass.resource_my_dood

    # byebug



    # @resource_manager_table_option = ResourceManager::ResourceManagerKlass.set_table_options

    resource_table_option = Resource::ResourceKlass.get_table_options
    resource_pagination = Resource::ResourceKlass.get_pagination
    # @table_option_option_list = TableOptionsHelper.default_table_options_for_form("orders#index")

    @table_options = resource_table_option


    # byebug


    # @table_option = @resource_manager_table_option


    @pagination_klass = resource_pagination



    @sort_orders_klass = ResourceManager::ResourceManagerKlass.set_sort_orders_klass
    # @pagination_klass = ResourceManager::ResourceManagerKlass.set_pagination
    #
    # @resource_table_option_klass = Resource::ResourceKlass.get_table_options
    # @resource_sort_orders_klass = Resource::ResourceKlass.get_sort_orders_klass
    # @resource_pagination_klass = Resource::ResourceKlass.get_pagination_klass



    ### Use ivars from Resource *********************
    ### Use ivars from Resource *********************
    ### Use ivars from Resource *********************

    # @table_option_klass = Resource::ResourceKlass.get_table_options
    # # @sort_orders_klass = Resource::ResourceKlass.get_sort_orders_klass
    # @sort_orders_klass = Resource::ResourceKlass.set_sort_orders_klass # fix to use get instead of set method
    # @pagination_klass = Resource::ResourceKlass.get_pagination_klass


    # @orders = Order.all
    @orders = @sort_orders_klass.sort_resource

    Resource::ResourceKlass.resource_my_dood
    ResourceManager::ResourceManagerKlass.resource_manager_my_dood

    # Resource::ResourceKlass.resource_done
    ResourceManager::ResourceManagerKlass.resource_manager_done

    puts "End of ResourceManager"

    # byebug



    # init_resource_manager = ResourceManager.init_resource_manager ( klass_attrs ) # Resource Data Object

    # @table_option_klass = ResourceManager::ResourceManagerKlass.set_table_options(user = @resource.user, parent_class = @resource.parent_class, action = @resource.parent_action, page = @resource.page)

    # byebug

    # init_service_manager = ServiceManager.init_new_service_manager( klass_attrs ) # method extended from ServiceManagerCore (Sets ivars)
    # ServiceManagerSort::SortDirection.new.is_satisfied_by?(@resource)


    # Resource::ResourceKlass.resource_done
    #
    # ServiceManagerPagination::PaginationKlass.new.is_satisfied_by?(@resource)
    # ServiceManagerSort::SortDirection.new.is_satisfied_by?(@resource)
    # #
    # spec =
    # ServiceManager::Composite.new(ServiceManagerTableOption::HasTableOption)
    # .and(ServiceManagerPagination::PaginationKlass)
    # .and(ServiceManagerSort::SortDirection)
    #
    # spec.is_satisfied_by?(@resource)
    #
    # ####################################################
    # ####################################################
    # # byebug ####### ***********************************
    #
    # @orders = Order.all

    # @table_option_klass = ResourceManager::ResourceManagerKlass.table_option_klass
    #
    # @sort_orders_klass = ResourceManager::ResourceManagerKlass.sort_orders_klass
    #
    # @pagination_klass = ResourceManager::ResourceManagerKlass.pagination_klass
    #
    # @orders = @sort_orders_klass.sort_resource
    #
    # byebug ####### *********************************
    # ####################################################
    # ####################################################

    @order = Order.new
    @order_content = @order != nil ? @order.build_order_content : OrderContent.new

    respond_to do |format|
      format.html
      # Donwnload Orders link in app/views/orders/_export_csv_button.html.erb, if link is clicked will be formatted through here
      format.csv {
        send_data @orders.resource.to_csv,
        filename: "Orders-#{(DateTime.now).try(:strftime,"%m/%d/%Y") }.csv",
        type: 'text/csv; charset=utf-8'
      }
      format.xls {
        send_data (Order.all).to_csv,
        filename: "LightningMarineServices_Orders-#{(DateTime.now).try(:strftime,"%m/%d/%Y") }.xls"
      }
    end
  end


  # GET /orders/1 or /orders/1.json
  def show
    @new_order = Order.new
    order ||= @order
    @new_order_content = @new_order != nil ? @new_order.build_order_content : OrderContent.new
  end

  # GET /orders/new
  def new
    @order = Order.new
    # @order.order_content.build
    # @order.order_content.new
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
    @order.build_order_content if @order.order_content.nil?
  end

  def create
    @order = Order.new order_params
    @order_content = @order.order_content
    # byebug
    if @order.save
      redirect_to order_path(@order), notice: "Order Created Successfully."
    else
      redirect_to request.referrer
      @order.errors.each do |error|
        flash[:alert] = @order.errors.full_messages.map {|message| message}
      end
    end
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      redirect_to request.referrer, notice: "Order Updated Successfully."
    else
      redirect_to request.referrer
      @order.errors.each do |error|
        flash[:alert] = @order.errors.full_messages.map {|message| message}
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order deleted successfully." }
      format.json { head :no_content }
    end
  end

  def destroy_attachment
    # byebug
    # image = ActiveStorage::Attachment.find(params[:id])
    image.purge
    redirect_to request.referrer, notice: "Image deleted successfully."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
      @order_content = @order.order_content
    end

    def order_params
      params.require(:order).permit(:id, :purchaser_id, :vendor_id, :dept, :po_number, :date_recieved, :courrier, :date_delivered, images: [], order_content_attributes: [ :id, :box, :crate, :pallet, :other, :other_description])
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
    end

end
