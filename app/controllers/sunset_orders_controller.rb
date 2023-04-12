# class OrdersController < ApplicationController
class SunsetOrdersController < ApplicationController
 layout "stacked_shell"

  before_action :authenticate_user!
  before_action :authenticate_admin, only: %i[ destroy ]
  # before_action :check_read_write, only: %i[ new, create ]
  # before_action :check_read_write, only: %i[ new, edit, create , update]

  before_action :set_page_heading_title
  before_action :set_order, only: %i[ show update destroy ]

  before_action :set_search_params, only: %i[ all_orders]
  before_action :set_pagination_params, only: %i[ all_orders ]
  helper_method :sort_option, :sort_direction

  # def all_orders
  #   load_resource_files
  #
  #   resource_attrs = {
  #     called_at: Time.now,
  #     user: current_user,
  #     target: Order.all,
  #     parent_class: Order,
  #     parent_action: 'all_orders',
  #     controller_name: 'orders',
  #     controller_action: 'all_orders',
  #     controller_name_and_action: 'orders#all_orders',
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
  # end
  def all_orders
    orders = Order.all

    if params[:query].present?
      query_str = params[:query]
      # results = orders.search(query_str).results
      # results = orders.search(query_str, misspellings: { below: 3} ).results
      results = orders.search(query_str, misspellings: { below: 6} ).results
      results_arr = Array.new
      results.each do |result|
        results_arr << result.id if (result.archived? == false)
      end
      @orders = nil
      # orders = Order.all.reorder('id ASC')
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
      format.csv { # give these formats a better home, shouldn't be in this controller or action
        send_data (Order.all).to_csv,
        filename: "Orders-#{(DateTime.now).try(:strftime,"%m/%d/%Y") }.csv",
        type: 'text/csv; charset=utf-8'
      }
      format.xls { # give these formats a better home, shouldn't be in this controller or action
        send_data (Order.all).to_csv, # method should be to_xls
        filename: "LightningMarineServices_Orders-#{(DateTime.now).try(:strftime,"%m/%d/%Y") }.xls"
      }
    end
  end


  def index
    orders = Order.unarchived

    if params[:query].present?
      query_str = params[:query]
      # results = orders.search(query_str).results
      # results = orders.search(query_str, misspellings: { below: 3} ).results
      results = orders.search(query_str, misspellings: { below: 6} ).results
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
      format.csv { # give these formats a better home, shouldn't be in this controller or action
        send_data (Order.all).to_csv,
        filename: "Orders-#{(DateTime.now).try(:strftime,"%m/%d/%Y") }.csv",
        type: 'text/csv; charset=utf-8'
      }
      format.xls { # give these formats a better home, shouldn't be in this controller or action
        send_data (Order.all).to_csv, # method should be to_xls
        filename: "LightningMarineServices_Orders-#{(DateTime.now).try(:strftime,"%m/%d/%Y") }.xls"
      }
    end
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

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

  def create
    #   check_read_write
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.turbo_stream { render turbo_stream: turbo_render_flash_notice_for_obj("Order was successfully created."), status: :created }
        format.html { redirect_to @order, notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else

        if request.variant == [:turbo_frame]
          format.turbo_stream { render turbo_stream: turbo_render_flash_errors_for_obj, status: :unprocessable_entity }
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
    respond_to do |format|
      if @order.update(order_params)

        if ( (request.variant == [:turbo_frame]) && !(request.referer.include? @order.id.to_s) )
          format.turbo_stream {
            render turbo_stream: [
              turbo_stream.replace(
                "order_#{@order.id}",
                partial: "/orders/table/row",
                locals: {
                  order: @order,
                }
              ),
              turbo_render_flash_notice_for_obj("Order was successfully updated.")
            ],
            status: :ok
          }
        end
        format.html { redirect_to @order, notice: "Order updated successfully." }
        format.json { render :show, status: :ok, location: @order }
      else
        # if ( (request.variant == [:turbo_frame]) && !(request.referer.include? @order.id.to_s) )
        #   format.turbo_stream { render turbo_stream: turbo_render_flash_errors_for_obj, status: :unprocessable_entity }
        # end
        if request.variant == [:turbo_frame]
          format.turbo_stream { render turbo_stream: turbo_render_flash_errors_for_obj, status: :unprocessable_entity }
        end
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    # @order = Order.find params[:id]

    @order.destroy
    respond_to do |format|
      if ( (request.variant == [:turbo_frame]) && !(request.referer.include? @order.id.to_s) )
        format.turbo_stream
      end
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

    def set_page_heading_title
      @page_heading_title = "Orders"
    end

    def turbo_render_flash_notice_for_obj(flash_title)
      turbo_stream.append(
        'flashes',
        partial: "/layouts/stacked_shell/headings/flash_messages",
        locals: {
          flash_type: "notice",
          flash_title: flash_title,
        }
      )
    end

    def turbo_render_flash_errors_for_obj
      delay_value = 3000
      flash_title = @order.errors.count > 1 ? "There were #{@order.errors.count} errors with your submission" : "There was #{@order.errors.count} error with your submission"

      flash_description = []
      @order.errors.each do |error|
        flash_description << error.full_message
        delay_value += 1500
      end
      flash_description = flash_description.join(" + ")  if flash_description.length > 1
      flash_description = flash_description.join  if flash_description.length == 1

      turbo_stream.append(
        'flashes',
        partial: "/layouts/stacked_shell/headings/flash_messages",
        locals: {
          delay_value: delay_value,
          flash_type: "alert",
          flash_title: @order.errors.count > 1 ? "There were #{@order.errors.count} errors with your submission" : "There was #{@order.errors.count} error with your submission",
          flash_description: flash_description,
        }
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

end
