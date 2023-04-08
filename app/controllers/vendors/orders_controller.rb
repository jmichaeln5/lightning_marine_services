class Vendors::OrdersController < OrdersController
  layout "stacked_shell"

  before_action :set_page_heading_title
  before_action :set_vendor, only: %i[ index new create ]
  before_action :set_orders, only: %i[ index ]

  def search_orders_against_query(orders, query_str)
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

    if ((params[:sort] != "ship_name") && ( params[:sort] != "vendor_name" )) # Order col
      orders = orders.reorder(sort_col => sort_dir)
    end

    return orders
  end

  def index
    orders = @vendor.orders

    if params[:query].present?
      orders = search_orders_against_query(orders, params[:query] )
      @orders = nil
    end

    if params[:sort].present?
      orders = sort_orders_against_params(orders, params[:sort] )
      @orders = nil
    end

    @orders ||= orders
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)

    @order = @vendor.orders.build   #replace with controller method new
    @order.build_order_content      #replace with controller method new

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

  def new
    @order = @vendor.orders.build
    @order.build_order_content
  end

  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        # format.html { redirect_to vendor_order_url(@vendor_order), notice: "Order was successfully created." }
        format.html { redirect_to @order, notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vendor
      @vendor = Vendor.includes(:orders).find(params[:vendor_id])
    end

    def set_orders
      @orders = @vendor.orders
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

    def set_page_heading_title
      @page_heading_title = "Vendor Orders"
    end

end
