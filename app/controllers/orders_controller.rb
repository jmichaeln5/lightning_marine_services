class OrdersController < ApplicationController
  # before_action :authenticate_user!
  # before_action :authenticate_admin, only: %i[ destroy ]
  # before_action :check_read_write, only: %i[ new, create ]
  # #before_action :check_read_write, only: %i[ new, edit, create , update]
  # before_action :set_order, only: %i[ show destroy ]
  # before_action :set_search_params, only: %i[ index all_orders]
  # before_action :set_pagination_params, only: %i[ index all_orders ]
  # helper_method :sort_option, :sort_direction


  before_action :authenticate_user!
  before_action :authenticate_admin, only: %i[ destroy ]
  before_action :check_read_write, only: %i[ new, create ]
  #before_action :check_read_write, only: %i[ new, edit, create , update]
  before_action :set_order, only: %i[ show destroy ]
  # before_action :set_search_params, only: %i[ all_orders]
  # before_action :set_pagination_params, only: %i[ all_orders ]
  # helper_method :sort_option, :sort_direction


  layout "stacked_shell", only: %i[ all_orders index show ]

  def all_orders
    load_resource_files

    resource_attrs = {
      called_at: Time.now,
      user: current_user,
      target: Order.all,
      parent_class: Order,
      parent_action: 'all_orders',
      controller_name: 'orders',
      controller_action: 'all_orders',
      controller_name_and_action: 'orders#all_orders',
      search_query: @query,
      sort_option: sort_option,
      sort_direction: sort_direction,
      page: @page
    }

    @init_resource = Resource.init_resource_klass ( resource_attrs )
    @resource = Resource::ResourceKlass.get_resource

    @table_option = @resource.table_option
    @orders = @resource.paginated_target
    @order = Order.new
    @order_content = @order != nil ? @order.build_order_content : OrderContent.new
  end

  # def index
  #   load_resource_files
  #
  #   resource_attrs = {
  #     called_at: Time.now,
  #     user: current_user,
  #     target: Order.unarchived,
  #     parent_class: Order,
  #     parent_action: 'index',
  #     controller_name: 'orders',
  #     controller_action: 'index',
  #     controller_name_and_action: 'orders#index',
  #     search_query: @query,
  #     sort_option: sort_option,
  #     sort_direction: sort_direction,
  #     page: @page
  #   }
  #
  #   @init_resource = Resource.init_resource_klass ( resource_attrs )
  #   @resource = Resource::ResourceKlass.get_resource
  #
  #   @table_option = @resource.table_option
  #   @orders = @resource.paginated_target
  #   @order = Order.new
  #   @order_content = @order != nil ? @order.build_order_content : OrderContent.new
  #
  #   respond_to do |format|
  #     format.html
  #     format.csv {
  #       send_data (Order.all).to_csv,
  #       filename: "Orders-#{(DateTime.now).try(:strftime,"%m/%d/%Y") }.csv",
  #       type: 'text/csv; charset=utf-8'
  #     }
  #     format.xls {
  #       send_data (Order.all).to_csv,
  #       filename: "LightningMarineServices_Orders-#{(DateTime.now).try(:strftime,"%m/%d/%Y") }.xls"
  #     }
  #   end
  # end



  ############################################################
  ############################################################
  ############################################################
  def index
    # orders = Order.unarchived
    orders = Order.where(archived: false)

    if params[:query].present?
      query_str = params[:query]

      # results = orders.search(query_str).results
      results = orders.search(query_str, misspellings: {below: 5}).results

      results_arr = Array.new
      results.each do |result|
        results_arr << result.id if (result.archived? == false)
      end
      orders = orders.where(id: results_arr)
      # if results_arr.length < 5
      #   included_results = Order.where(archived: false).search( query_str, includes: [:purchaser, :vendor]).results
      #
      #   included_results_arr = Array.new
      #   included_results.each do |included_result|
      #     included_results_arr << included_result.id if (included_result.archived? == false)
      #   end
      #   orders = Order.unarchived.where(id: included_results_arr)
      # end
    end
    # @orders = orders
    # @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)

    if params[:sort]
      old_order_ids = orders.pluck(:id)
      old_orders = orders

      if params[:sort] == "ship_name"
        sorted_included_query_orders = orders.includes(:purchaser).references(:purchaser).order("name" + " " + sort_dir)
        new_order_ids = sorted_included_query_orders.pluck(:id)
      end

      if params[:sort] == "vendor_name"
        sorted_included_query_orders = orders.includes(:vendor).references(:vendor).order("name" + " " + sort_dir)
        new_order_ids = sorted_included_query_orders.pluck(:id)
      end

      if new_order_ids && ( (params[:sort] == "ship_name") || ( params[:sort] == "vendor_name" ) )
        order_query = <<-SQL
          CASE orders.id
            #{new_order_ids.map.with_index { |id, index| "WHEN #{id} THEN #{index}" } .join(' ')}
            ELSE #{new_order_ids.length}
          END
        SQL
        satisfied_sorted_orders = Order.where(id: new_order_ids).order(Arel.sql(order_query))

        @orders = nil
        orders = nil

        orders = satisfied_sorted_orders
        sorted_orders = orders
        @sorted_orders = orders
        @orders = orders
      end

      if ((params[:sort] != "ship_name") && ( params[:sort] != "vendor_name" ))
        orders = orders.reorder(sort_col => sort_dir)
        @orders = orders
      end
    end

    ### Good for testing/debugging atm
    #############################################
    # if ( (params[:sort] == "ship_name") || ( params[:sort] == "vendor_name" ) )
      # byebug
    # end
    # old_orders.map {|o| o.id }
    # @orders.map {|o| o.id }
    # orders.map {|o| o.id }
    # @sorted_orders.map {|o| o.id }
    #############################################

    @orders ||= orders
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)

    respond_to do |format|
      format.html
      format.csv {
        send_data (Order.all).to_csv,
        filename: "Orders-#{(DateTime.now).try(:strftime,"%m/%d/%Y") }.csv",
        type: 'text/csv; charset=utf-8'
      }
      format.xls {
        send_data (Order.all).to_csv,
        filename: "LightningMarineServices_Orders-#{(DateTime.now).try(:strftime,"%m/%d/%Y") }.xls"
      }
    end
  end

  def sort_col
    %w{ id dept date_recieved courrier date_delivered }.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_dir
    %w{ asc desc }.include?(params[:direction]) ? params[:direction] : "asc"
  end
  ############################################################
  ############################################################
  ############################################################











  # GET /orders/1 or /orders/1.json
  def show
    load_resource_files

    resource_attrs = {
      called_at: Time.now,
      user: current_user,
      target: @order,
      parent_class: Order,
      parent_action: 'show',
      controller_name: 'orders',
      controller_action: 'show',
      controller_name_and_action: 'orders#show',
      search_query: @query,
      sort_option: sort_option,
      sort_direction: sort_direction,
      page: @page
    }

    @new_order = Order.new
    order ||= @order
    @new_order_content = @new_order != nil ? @new_order.build_order_content : OrderContent.new
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
    @order.build_order_content if @order.order_content.nil?
  end

  def create
    @order = Order.new order_params
    @order.po_number = 'n/a' if @order.po_number == ""
    @order.dept = 'n/a' if @order.dept == ""
    @order_content = @order.order_content
    if @order.save
      redirect_back(fallback_location: order_path(@order),notice: "Order Created Successfully.")
    else
      redirect_to request.referrer
      @order.errors.each do |error|
        flash[:alert] = @order.errors.full_messages.map {|message| message}
      end
    end
  end

  def update
    @order = Order.find(params[:id])
    #logic to default number
    #@order.order_sequence = @order.sequence

    if @order.update(order_params)
      redirect_back(fallback_location: order_path(@order),notice: "Order Updated Successfully.")
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
      # Only Guest account to update Department Only
      if (current_user.has_role?('admin') || current_user.has_role?('staff'))
      params.require(:order).permit(:id, :purchaser_id, :vendor_id, :order_sequence, :dept, :po_number, :tracking_number, :date_recieved, :courrier, :date_delivered, images: [], order_content_attributes: [ :id, :box, :crate, :pallet, :other, :other_description])
      else
        params.require(:order).permit(:dept)
      end
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
