class OrdersController < ApplicationController
 layout "stacked_shell"

  before_action :authenticate_user!
  before_action :authenticate_admin, only: %i[ destroy ]

  before_action :set_page_heading_title
  before_action :set_order, only: %i[ show update destroy ]

  def search_orders_against_query(orders, query_str)
    dev_output_str("OrdersController#search_orders_against_query")

    results = orders.search(query_str, misspellings: { below: 6} ).results
    results_arr = Array.new
    results.each do |result|
      results_arr << result.id if (result.archived? == false)
    end
    # orders = orders.reorder('id ASC')
    orders = orders.where(id: results_arr)
    return orders
  end

  def arel_reorder(sorted_orders_ids_arr)
    dev_output_str("OrdersController#arel_reorder")

    # https://stackoverflow.com/a/61267426
    order_query = <<-SQL
      CASE orders.id
        #{sorted_orders_ids_arr.map.with_index { |id, index| "WHEN #{id} THEN #{index}" } .join(' ')}
        ELSE #{sorted_orders_ids_arr.length}
      END
    SQL

    newly_sorted_orders = Order.where(id: sorted_orders_ids_arr).order(Arel.sql(order_query))
    clear_active_record_query_cache

    orders = newly_sorted_orders
    return orders
  end

  def sort_orders_against_params(orders, sort_param)
    dev_output_str("OrdersController#sort_orders_against_params")

    sort_col = %w{ id dept date_recieved courrier date_delivered }.include?(params[:sort]) ? params[:sort] : "id"
    sort_dir = %w{ asc desc }.include?(params[:direction]) ? params[:direction] : "asc"

    if ((params[:sort] == "ship_name") || ( params[:sort] == "vendor_name" )) # None Order col
      sorted_orders = Order.where(id: orders.ids).filter_by_purchasers(sort_dir) if params[:sort] == "ship_name"
      sorted_orders = Order.where(id: orders.ids).filter_by_purchasers(sort_dir) if params[:sort] == "purchaser_name"
      sorted_orders = Order.where(id: orders.ids).filter_by_vendors(sort_dir) if params[:sort] == "vendor_name"

      sorted_orders_ids = sorted_orders.ids
      sorted_orders_ids_arr = Array.new
      sorted_orders_ids.each do |order_id|
        sorted_orders_ids_arr << order_id
      end

      orders = arel_reorder(sorted_orders_ids_arr)
    end

    if ((params[:sort] != "ship_name") && (params[:sort] != "purchaser_name") && ( params[:sort] != "vendor_name" )) # sorting order col
      orders = orders.reorder(sort_col => sort_dir)
    end

    return orders
  end

  def resolve_orders_for_data_table(orders)
    dev_output_str("OrdersController#resolve_orders_for_data_table")

    orders = search_orders_against_query(orders, params[:query] ) if params[:query].present?
    orders = sort_orders_against_params(orders, params[:sort] ) if params[:sort].present?
    return orders
  end

  def all_orders
    @orders = nil
    orders = Order.all

    @orders ||= resolve_orders_for_data_table(orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
  end

  def index
    @orders = nil
    orders = Order.all

    @orders ||= resolve_orders_for_data_table(orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order

    respond_to do |format|
      format.html
      format.csv { # give these formats a better home, shouldn't be in this controller or action
        send_data (@orders).to_csv,
        filename: "Orders-#{(DateTime.now).try(:strftime,"%m/%d/%Y") }.csv",
        type: 'text/csv; charset=utf-8'
      }
      format.xls { # give these formats a better home, shouldn't be in this controller or action
        send_data (@orders).to_csv, # method should be to_xls
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
    set_new_order
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
        format.turbo_stream { render turbo_stream: turbo_render_flash_order_notice("Order was successfully created."), status: :created }
        format.html { redirect_to @order, notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else

        if request.variant == [:turbo_frame]
          format.turbo_stream { render turbo_stream: turbo_render_flash_order_errors, status: :unprocessable_entity }
        end

        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

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
              turbo_render_flash_order_notice("Order was successfully updated.")
            ],
            status: :ok
          }
        end
        format.html { redirect_to @order, notice: "Order updated successfully." }
        format.json { render :show, status: :ok, location: @order }
      else
        # if ( (request.variant == [:turbo_frame]) && !(request.referer.include? @order.id.to_s) )
        #   format.turbo_stream { render turbo_stream: turbo_render_flash_order_errors, status: :unprocessable_entity }
        # end
        if request.variant == [:turbo_frame]
          format.turbo_stream { render turbo_stream: turbo_render_flash_order_errors, status: :unprocessable_entity }
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

    def set_new_order
      @order = Order.new
      @order.build_order_content
    end

    def set_page_heading_title
      @page_heading_title = "Orders"
    end

    def turbo_render_flash_order_notice(flash_title)
      turbo_stream.append(
        'flashes',
        partial: "/layouts/stacked_shell/headings/flash_messages",
        locals: {
          flash_type: "notice",
          flash_title: flash_title,
        }
      )
    end

    def turbo_render_flash_order_errors
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

end
