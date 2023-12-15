class OrdersController < Orders::BaseController
  before_action :authorize_internal_user, only: %i[ new create edit destroy ]
  before_action :set_page_heading_title
  before_action :set_order, only: %i[ show hovercard update destroy ]

  def index
    orders = Order.unarchived
    orders = orders.order(created_at: :desc)
    @orders = resolve_orders_for_data_table(orders)
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

  def show
  end

  def new
    set_new_order
  end

  def edit
    @order = Order.find(params[:id])
    # @order.build_order_content if @order.order_content.nil?
    # @order.order_contents.build if @order.order_content.nil?
  end

  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.turbo_stream { render turbo_stream: turbo_render_flash_order_notice("Order was successfully created."), status: :created }
        format.html { redirect_to @order, notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        if Current.request_variant == :turbo_frame
          format.turbo_stream { render turbo_stream: turbo_render_flash_order_errors, status: :unprocessable_entity }
        end
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if !authorized_internal_user?
      veto_unauthorized_request unless authorized_customer? && order_params.keys == ["dept"]
    end
    # ApplicationPolicy.new(Current.user, Order.find_by_id(params[:id]))
    # OrdersPolicy.new(Current.user, Order.find_by_id(params[:id]))
    respond_to do |format|
      if @order.update(order_params)
        if ( (Current.request_variant == :turbo_frame) && !(request.referer.include? @order.id.to_s) )
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
        if Current.request_variant == :turbo_frame
          format.turbo_stream { render turbo_stream: turbo_render_flash_order_errors, status: :unprocessable_entity }
        end
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy
    respond_to do |format|
      if ( (Current.request_variant == :turbo_frame) && !(request.referer.include? @order.id.to_s) )
        format.turbo_stream
      end
      format.html { redirect_to orders_url, notice: "Order deleted successfully." }
      format.json { head :no_content }
    end
  end

  def all_orders
    orders = Order.all
    orders = orders.order(created_at: :desc)
    @orders = resolve_orders_for_data_table(orders)

    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
  end

  def completed_orders
    orders = Order.archived
    orders = orders.order(created_at: :desc)
    @orders = resolve_orders_for_data_table(orders)

    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(
        :dept, :po_number, :tracking_number, :date_recieved, :courrier, :date_delivered, :purchaser_id, :vendor_id, :order_sequence,
        images: [],
        # order_content_attributes:[
        order_contents_attributes:[
          :id, :box, :crate, :pallet, :other, :other_description
        ]
      )
    end

    def set_new_order
      @order = Order.new
      # @order.build_order_content
      @order.order_contents.build
      # @order.order_contents.build if @order.order_content.nil?


    end

    def turbo_render_flash_order_notice(flash_title) # move to concern
      turbo_stream.append(
        'flashes',
        partial: "/layouts/stacked_shell/headings/flash_messages",
        locals: {
          flash_type: "notice",
          flash_title: flash_title,
        }
      )
    end
end
