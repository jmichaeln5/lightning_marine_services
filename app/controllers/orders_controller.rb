class OrdersController < ApplicationController
 #  layout "stacked_shell", only: %i[ all_orders index show new]
 layout "stacked_shell"

  before_action :authenticate_user!
  before_action :authenticate_admin, only: %i[ destroy ]
  # before_action :check_read_write, only: %i[ new, create ]
  # before_action :check_read_write, only: %i[ new, edit, create , update]
  # before_action :set_order, only: %i[ show destroy ]
  before_action :set_search_params, only: %i[ all_orders]
  before_action :set_pagination_params, only: %i[ all_orders ]
  helper_method :sort_option, :sort_direction

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
  def index
    orders = Order.unarchived

    if params[:query].present?
      query_str = params[:query]
      # results = orders.search(query_str).results
      results = orders.search(query_str, misspellings: {below: 3}).results
      results_arr = Array.new
      results.each do |result|
        results_arr << result.id if (result.archived? == false)
      end
      @orders = nil
      orders = Order.unarchived.reorder('id ASC')
      orders = orders.where(id: results_arr)
    end

    if params[:sort]
      sort_col = %w{ id dept date_recieved courrier date_delivered }.include?(params[:sort]) ? params[:sort] : "id"
      sort_dir = %w{ asc desc }.include?(params[:direction]) ? params[:direction] : "asc"

      if ((params[:sort] == "ship_name") || ( params[:sort] == "vendor_name" )) # None Order col
        sorted_orders = Order.where(id: orders.ids).filter_by_purchasers(sort_dir) if params[:sort] == "ship_name"
        sorted_orders = Order.where(id: orders.ids).filter_by_vendors(sort_dir) if params[:sort] == "vendor_name"
        sorted_orders_ids = sorted_orders.ids
        sorted_orders_ids_arr = Array.new

        sorted_orders_ids.each do |order_id|
          sorted_orders_ids_arr << order_id
        end
        # https://stackoverflow.com/a/61267426
        order_query = <<-SQL
          CASE orders.id
            #{sorted_orders_ids_arr.map.with_index { |id, index| "WHEN #{id} THEN #{index}" } .join(' ')}
            ELSE #{sorted_orders_ids_arr.length}
          END
        SQL

        newly_sorted_orders = Order.where(id: sorted_orders_ids_arr).order(Arel.sql(order_query))
        clear_active_record_query_cache
      end

      if ((params[:sort] != "ship_name") && ( params[:sort] != "vendor_name" )) # Order col
        newly_sorted_orders = orders.reorder(sort_col => sort_dir)
      end

      @orders = nil
      orders = nil
      orders = newly_sorted_orders
    end

    @orders ||= orders
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)

    @order = Order.new
    @order.build_order_content

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

  ################################################
  ################################################
  ################################################
  ################################################
  # # GET /orders/1 or /orders/1.json
  # def show
  #   set_order
  #   load_resource_files
  #
  #   resource_attrs = {
  #     called_at: Time.now,
  #     user: current_user,
  #     target: @order,
  #     parent_class: Order,
  #     parent_action: 'show',
  #     controller_name: 'orders',
  #     controller_action: 'show',
  #     controller_name_and_action: 'orders#show',
  #     search_query: @query,
  #     sort_option: sort_option,
  #     sort_direction: sort_direction,
  #     page: @page
  #   }
  #
  #   @new_order = Order.new
  #   order ||= @order
  #   @new_order_content = @new_order != nil ? @new_order.build_order_content : OrderContent.new
  # end
  ################################################
  # GET /orders/1 or /orders/1.json
  def show
    @order = Order.find params[:id]
  end
  ################################################
  ################################################
  ################################################

  # GET /orders/new
  def new
    check_read_write

    @order = Order.new
    @order.build_order_content
  end

  # GET /orders/1/edit
  def edit
    # check_read_write
    @order = Order.find(params[:id])
    @order.build_order_content if @order.order_content.nil?
  end

  # def create
  #   check_read_write
  #   @order = Order.new(order_params)
  #
  #   respond_to do |format|
  #     if @order.save
  #       format.html { redirect_to @order, notice: "Order was successfully created." }
  #       # format.html { redirect_to order_path(@order), notice: "Order was successfully created." }
  #       format.json { render :show, status: :created, location: @order }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @order.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  def create
  @order = Order.new(order_params)

  respond_to do |format|
    if @order.save
      format.html { redirect_to @order, notice: "Order was successfully created." }
      format.json { render :show, status: :created, location: @order }
    else

      if request.variant == [:turbo_frame]
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.replace(
            'modal_form',
            partial: "/orders/modal_form",
            locals: {
              order: @order,
            }
          ),
        ],
        status: :unprocessable_entity
      }
      end

      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @order.errors, status: :unprocessable_entity }
    end
  end
end

  # def update
  #   check_read_write
  #   @order = Order.find(params[:id])
  #   #logic to default number
  #   #@order.order_sequence = @order.sequence
  #
  #   if @order.update(order_params)
  #     redirect_back(fallback_location: order_path(@order),notice: "Order Updated Successfully.")
  #   else
  #     redirect_to request.referrer
  #     @order.errors.each do |error|
  #       flash[:alert] = @order.errors.full_messages.map {|message| message}
  #     end
  #   end
  # end
  def update
    @order = Order.find(params[:id])
    #logic to default number
    #@order.order_sequence = @order.sequence
    respond_to do |format|
      if @order.update(order_params)

        # if request.variant == [:turbo_frame]  # replaces "order_#{@order.id" on #index + #show # should only upd8 + replace on #shoow
          if ((request.variant == [:turbo_frame] )&& !(request.path.include? @order.id.to_s)) # need a better solution
          format.turbo_stream {
            render turbo_stream: [
              # turbo_stream.replace(
              turbo_stream.replace(
                "order_#{@order.id}",
                partial: "/orders/row",
                locals: {
                  order: @order,
                }
              ),
            ],
            status: :ok
          }
        end
        format.html { redirect_to @order, notice: "Order updated successfully." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order = Order.find params[:id]

    @order.destroy
    respond_to do |format|
      format.turbo_stream
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

    # def order_params
    #   # Only Guest account to update Department Only
    #   if (current_user.has_role?('admin') || current_user.has_role?('staff'))
    #   params.require(:order).permit(:id, :purchaser_id, :vendor_id, :order_sequence, :dept, :po_number, :tracking_number, :date_recieved, :courrier, :date_delivered, images: [], order_content_attributes: [ :id, :box, :crate, :pallet, :other, :other_description])
    #   else
    #     params.require(:order).permit(:dept)
    #   end
    # end
    def order_params
      params.require(:order).permit(
        :dept,
        :po_number,
        :tracking_number,
        :date_recieved,
        :courrier,
        :date_delivered,
        :purchaser_id,
        :vendor_id,
        :order_sequence,
        images: [],
        order_content_attributes: [
          :id,
          :box,
          :crate,
          :pallet,
          :other,
          :other_description
        ]
      )
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

    def clear_active_record_query_cache
      puts (" \n")*5
      puts ("*"*50 + "\n")*10
      puts ("clearing ActiveRecord query_cache \n")*5
      puts ("*"*50 + "\n")*10
      puts (" \n")*5

      ActiveRecord::Base.connection.query_cache.clear
    end

end
