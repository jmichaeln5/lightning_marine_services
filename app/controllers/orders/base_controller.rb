class Orders::BaseController < ApplicationController
  include DestroyAttachable
  include Orders::Exportable, Orders::Filterable, Orders::ResourceScoped, Orders::Sortable, Orders::Statusable

  layout "stacked_shell"

  def resolve_orders_for_data_table(orders)
    dev_output_str("OrdersTableHelper#resolve_orders_for_data_table")

    orders = filter_orders(orders) if filter?
    orders = sort_orders(orders) if sort?
    orders = search_orders_against_query(orders, query_param ) if query_param.present? and query_param.length > 1

    return orders
  end

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
    def query_param
      params[:query]
    end

    def search_orders_against_query(orders, query_str)
      dev_output_str("OrdersTableHelper#search_orders_against_query")

      results = orders.search(query_str, misspellings: { below: 6} ).results
      results_arr = Array.new
      results.each do |result|
        results_arr << result.id if (result.archived? == false)
      end
      orders = orders.where(id: results_arr)
      return orders
    end

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
