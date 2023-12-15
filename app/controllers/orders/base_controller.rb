class Orders::BaseController < ApplicationController
  include DestroyAttachable
  include OrdersTableHelper

  layout "stacked_shell"

  def hovercard
  end

  def edit_dept
    ensure_frame_response
    set_order

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private
    def set_page_heading_title
      @page_heading_title = "Orders"
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
