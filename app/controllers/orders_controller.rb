class OrdersController < Orders::BaseController
  before_action :authorize_internal_user, only: %i(index), if: :vendor?
  before_action :authorize_internal_user, only: %i(new create edit destroy)

  before_action :set_scoped_resource, if: :scoped_resource?
  before_action :set_order, only: %i(show hovercard edit update destroy)

  # ⚠️ 👇🏾  wayyyy too many status helper methods, using for link+button_to.., refactor said fuckery
  helper_method %i(
    status_param
    scoped_status?
    scoped_status
    valid_status_params
    status_param_valid?
    status_scopes
    status_scopes_names
    status_display_name
  )

  helper_method %i(
    scoped_resource?
    purchaser?
    vendor?
  )

  def index
    scoped_resource? ? set_scoped_resource_orders : set_orders
    @orders = resolve_orders_for_data_table(@orders)

    @pagy, @orders = pagy(
      @orders,
      link_extra: 'data-turbo-frame="orders" data-turbo-action="advance"',
      items: params.fetch(:count, 10)
    ) unless format_export?

    respond_to do |format|
      format.html and return if :html.in?(formats)

      @data_table = DataTable::Orders.new(records = @orders)
      @filename = get_filename(status: scoped_status, scoped_resource: @scoped_resource)

      respond_to_export_format(format, data_table: @data_table, filename: @filename)
    end
  end

  def show
    @order_content = @order.order_content
    @order_content ||= @order.build_order_content
    @packaging_materials = @order.packaging_materials.order(created_at: :desc)
  end

  def new
    @order = scoped_resource? ? @scoped_resource.orders.build : Order.new
    @order_content = @order.build_order_content
    @packaging_material = @order.order_content.packaging_materials.build
  end

  def edit
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
        :order_sequence,
        :status,
        :dept,
        :purchaser_id,
        :vendor_id,
        :po_number,
        :date_recieved,
        :courrier,
        :date_delivered,
        images: [],
        order_content_attributes:[
          :id, :box, :crate, :pallet, :other, :other_description,
          packaging_materials_attributes:[
            :id, :type, :description, :_destroy,
          ]
        ]
      )
    end

    def set_orders
      @orders = Order.includes(
        :order_content,
        :purchaser,
        :vendor
      ).where(status: status_scopes).reorder(id: :desc)
    end

    def set_order
      @order = Order.find(params[:id])
    end

    def set_page_heading_title
      @page_heading_title = scoped_resource? ? @scoped_resource.display_name : "Orders"
    end
end
