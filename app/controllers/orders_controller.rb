class OrdersController < Orders::BaseController
  before_action :authorize_internal_user, only: %i[ new create edit destroy ]
  before_action :set_page_heading_title

  before_action :set_order, only: %i(show hovercard update destroy)
  before_action :set_new_order, only: %i(new) # callback required, overwriting in child controllers to build order on parent

  def index
    orders = Order.unarchived
    orders = orders.order(created_at: :desc)
    @orders = resolve_orders_for_data_table(orders)

    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
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

  def show
    @order_content = @order.order_content
    @order_content ||= @order.build_order_content
    @packaging_materials = @order.packaging_materials.order(created_at: :desc)
  end

  def new
  end

  def edit
    @order = Order.find(params[:id])
    @order_content = (@order.order_content.nil?) ? @order.build_order_content : @order.order_content
  end

  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.append('flashes', partial: "/layouts/stacked_shell/headings/flash_messages", locals: {
              flash_type: 'notice',
              flash_title: "Order created successfully.",
            }
          ),
          status: :created
        }
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
    respond_to do |format|
      if @order.update(order_params)
        format.turbo_stream {}
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

  private
    def order_params
      params.require(:order).permit(
        :dept, :po_number, :tracking_number, :date_recieved, :courrier, :date_delivered, :purchaser_id, :vendor_id, :order_sequence,
        images: [],
        order_content_attributes:[
          :id, :box, :crate, :pallet, :other, :other_description,
          packaging_materials_attributes:[
            :id, :type, :description, :_destroy,
          ]
        ],
      )
    end

    def set_order
      @order = Order.find(params[:id])
    end

    def set_new_order  # method required, overwriting in child controllers to build order on parent
      @order = Order.new
      @order_content = @order.build_order_content
      @packaging_material = @order.order_content.packaging_materials.build
    end
end
