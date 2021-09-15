class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, only: %i[ destroy ]
  before_action :set_order, only: %i[ show destroy ]
  before_action :load_modules
  helper_method :sort_option, :sort_direction

  def all_orders
    @order = Order.new
    @order_content = @order != nil ? @order.build_order_content : OrderContent.new
    @orders = OrdersSortTableLogic.sorted_orders(sort_option, sort_direction)
    @archived_orders = Order.archived.order("created_at DESC")
    @unarchived_orders = Order.unarchived.order("created_at DESC")
  end

  # GET /orders or /orders.json
  def index
    @orders_per_page = 5
    @archived_orders = Order.archived.order("created_at DESC")

    @orders = OrdersSortTableLogic.sorted_orders(sort_option, sort_direction)

    #   # http://localhost:3000/orders?page=2?order_attr=id&sort_direction=DESC

    @get_page = params.fetch(:page, 0).to_i
    @page_number = params.fetch(:page, 0).to_i


    @page = @get_page
    @set_page = @page_number * @orders_per_page


    if request.original_fullpath.include? "order_attr" || "sort_direction"
      @page_number = params.fetch(:page, 0).to_i
      @paginated_orders = @orders.offset(@set_page).limit(@orders_per_page)
    else
      @paginated_orders = @orders.offset(@set_page).limit(@orders_per_page)
    end

    @current_page_number = params.fetch(:page, 0)
    @total_pages = Order.all.count.to_i / @orders_per_page

    # @paginated_orders = @orders.offset(@set_page).limit(@orders_per_page)

    #################
    ### # Form Instance Vars
    @order = Order.new
    @order_content = @order != nil ? @order.build_order_content : OrderContent.new

    ### # Export to CSV
    # respond_to do |format|
    #   format.html
    #   format.csv do
    #     headers['Content-Disposition'] = "attachment; filename=\"orders-list\""
    #     headers['Content-Type'] ||= 'text/csv'
    #   end
    # end
    #################
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

    def load_modules
      autoload :OrdersSortTableLogic, "orders/sort_logic/orders_sort_table_logic.rb"
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
