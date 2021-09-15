class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, only: %i[ destroy ]
  before_action :set_order, only: %i[ show destroy ]
  helper_method :sort_option, :sort_direction

  def all_orders
    autoload :OrdersSortTableLogic, "orders/sort_logic/orders_sort_table_logic.rb"

    @order = Order.new
    @order_content = @order != nil ? @order.build_order_content : OrderContent.new
    @orders = OrdersSortTableLogic.sorted_orders(sort_option, sort_direction)
    @archived_orders = Order.archived.order("created_at DESC")
    @unarchived_orders = Order.unarchived.order("created_at DESC")
  end

  def index
    autoload :OrdersSortTableLogic, "orders/sort_logic/orders_sort_table_logic.rb"

    @sorted_orders = OrdersSortTableLogic.sorted_orders(sort_option, sort_direction)
    @order = Order.new
    @order_content = @order != nil ? @order.build_order_content : OrderContent.new

    @orders_per_page = 10
    @page = params.fetch(:page, 0).to_i
    @offset_arg = @page * @orders_per_page
    @orders = @sorted_orders.offset(@offset_arg).limit(@orders_per_page)

    #  For pagination btns
    @total_pages = @sorted_orders.length.to_i / @orders_per_page

    #   #################
    #   ### # Export to CSV
    #   # respond_to do |format|
    #   #   format.html
    #   #   format.csv do
    #   #     headers['Content-Disposition'] = "attachment; filename=\"orders-list\""
    #   #     headers['Content-Type'] ||= 'text/csv'
    #   #   end
    #   # end
    #   #################
  end




  def archived_index
    @archived_orders = Order.archived.order("created_at DESC")
    @unarchived_orders = Order.unarchived.order("created_at DESC")
    @orders = Order.all
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
      # sort_option = params[:sort_option] ||= nil unless params[:sort_option] == 'ship'
      # sort_option = params[:sort_option] == 'ship' ? 'purchaser_id' : params[:sort_option]
    end

    def sort_direction(sort_direction = nil)
      sort_direction = params[:sort_direction] == "desc" ? "asc" : "desc"
    end

end
