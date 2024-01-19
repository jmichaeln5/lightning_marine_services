class Purchasers::OrdersController < OrdersController
  def index
    @purchaser = Purchaser.includes(:orders).find(params[:purchaser_id])
    # orders = @purchaser.orders.active
    orders = @purchaser.orders.unarchived
    orders = orders.order(order_sequence: :asc)
    @orders = resolve_orders_for_data_table(orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
  end

  def all_orders
    @purchaser = Purchaser.includes(:orders).find(params[:id])

    orders = @purchaser.orders.all
    orders = orders.order(order_sequence: :asc)
    @orders = resolve_orders_for_data_table(orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
  end

  def completed_orders
    @purchaser = Purchaser.includes(:orders).find(params[:id])

    orders = @purchaser.orders.archived
    orders = orders.order(order_sequence: :asc)
    @orders = resolve_orders_for_data_table(orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
  end

  def deliver_active
    purchaser = Purchaser.includes(:orders).find(params[:purchaser_id])

    purchaser.orders.where(status: :active).update_all(status: :archived)

    redirect_to purchaser_orders_path(purchaser), notice: "#{purchaser.name} active orders delivered successfully."
  end

  def export
    filePrefix = (@purchaser.name + "_").parameterize(separator: '_')
    @orders = @purchaser.orders.unarchived
    respond_to do |format|
      format.html {
        render :export
      }
      format.xls {
        send_data @orders.to_csv,
        filename: filePrefix + "Orders-#{(DateTime.now).try(:strftime,"%m/%d/%Y") }.xls"
      }
      format.xlsx {
        fName = filePrefix + "_Orders-#{(DateTime.now).try(:strftime,"%m/%d/%Y") }.xlsx"
        response.headers['Content-Disposition'] = 'attachment; filename="' + fName + '"'
      }
    end
  end

  private
    def set_new_order
      if params[:purchaser_id]
        @purchaser = Purchaser.find(params[:purchaser_id])
      end
      @purchaser ||= Purchaser.find(params[:id])

      @order = @purchaser.orders.build
      @order.build_order_content
      @page_heading_title = "Ship: #{@purchaser.name}"
    end
end
