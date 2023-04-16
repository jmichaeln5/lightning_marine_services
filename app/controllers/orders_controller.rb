class OrdersController < ApplicationController
 layout "stacked_shell"

 include OrdersTableHelper

 # before_action :ensure_frame_response, only: %i[ new ]
  before_action :authorize_internal_user, only: %i[ new create edit destroy ]

  before_action :set_page_heading_title
  before_action :set_order, only: %i[ show hovercard update destroy ]

  def all_orders
    orders = Order.all

    @orders ||= resolve_orders_for_data_table(orders)
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)
    set_new_order
  end

  def index
    orders = Order.unarchived

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

  def hovercard
  end

  # GET /orders/new
  def new
    set_new_order
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
    @order.build_order_content if @order.order_content.nil?
  end

  def edit_dept
    ensure_frame_response
    set_order

    respond_to do |format|
      format.html
      format.turbo_stream
    end
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
        # if ( (Current.request_variant == :turbo_frame) && !(request.referer.include? @order.id.to_s) )
        #   format.turbo_stream { render turbo_stream: turbo_render_flash_order_errors, status: :unprocessable_entity }
        # end
        if Current.request_variant == :turbo_frame
          format.turbo_stream { render turbo_stream: turbo_render_flash_order_errors, status: :unprocessable_entity }
        end
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
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
