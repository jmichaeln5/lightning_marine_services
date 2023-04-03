class VendorsController < ApplicationController
  layout "stacked_shell"

  before_action :authenticate_user!
  before_action :authenticate_admin, only: %i[ destroy ]

  before_action :set_page_header_title
  before_action :set_vendor, only: %i[ show edit update destroy ]

  # GET /vendors or /vendors.json
  def index
    @vendors = Vendor.all
    # vendors = Vendor.all
    # @pagy, @vendors = pagy @vendors.reorder(sort_column => sort_direction), items: params.fetch(:count, 10)

    sort_vendors if params[:sort]
    @pagy, @vendors = pagy @vendors, items: params.fetch(:count, 10)
  end

  def sort_column
    %w{ id name order_amount }.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w{ asc desc }.include?(params[:direction]) ? params[:direction] : "asc"
  end

  def sort_vendors
    if params[:sort] == "order_amount"
      Vendor.left_joins(:orders).group(:id).reorder("COUNT(orders.id) #{sort_direction}")
      @vendors = nil
      vendors = Vendor.left_joins(:orders).group(:id).reorder("COUNT(orders.id) #{sort_direction}")
    else
      # vendors = @vendors.reorder(sort_column => sort_direction) if %w{ id name order_amount }.include?(params[:sort])
      vendors = @vendors.reorder(sort_column => sort_direction) if %w{ id name order_amount }.include?(params[:sort])
      @vendors = nil
    end
    clear_active_record_query_cache
    @vendors = vendors
  end

  # GET /vendors/1 or /vendors/1.json
  # def show
  # end
  def show
    orders = Order.unarchived.where(vendor: @vendor)

    if params[:query].present?
      query_str = params[:query]
      results = orders.search(query_str, misspellings: {below: 3}).results
      results_arr = Array.new
      results.each do |result|
        results_arr << result.id if (result.archived? == false)
      end
      @orders = nil
      orders = Order.unarchived.where(vendor: @vendor).reorder('id ASC')
      orders = orders.where(id: results_arr)
    end

    if params[:sort]
      sort_col = %w{ id dept date_recieved courrier date_delivered }.include?(params[:sort]) ? params[:sort] : "id"
      sort_dir = %w{ asc desc }.include?(params[:direction]) ? params[:direction] : "asc"

      if ((params[:sort] == "ship_name") || ( params[:sort] == "vendor_name" )) # None Order col
        sorted_orders = Order.where(id: orders.ids).filter_by_purchasers(sort_dir) if params[:sort] == "ship_name"
        sorted_orders = Order.where(id: orders.ids).filter_by_vendors(sort_dir) if params[:sort] == "vendor_name"
        sorted_orders_ids = sorted_orders.ids
        sorted_orders_ids_arr = Array.new

        sorted_orders_ids.each do |order_id|
          sorted_orders_ids_arr << order_id
        end
        # https://stackoverflow.com/a/61267426
        order_query = <<-SQL
          CASE orders.id
            #{sorted_orders_ids_arr.map.with_index { |id, index| "WHEN #{id} THEN #{index}" } .join(' ')}
            ELSE #{sorted_orders_ids_arr.length}
          END
        SQL

        newly_sorted_orders = Order.where(id: sorted_orders_ids_arr).order(Arel.sql(order_query))
        clear_active_record_query_cache
      end

      if ((params[:sort] != "ship_name") && ( params[:sort] != "vendor_name" )) # Order col
        newly_sorted_orders = orders.reorder(sort_col => sort_dir)
      end

      @orders = nil
      orders = nil
      orders = newly_sorted_orders
    end

    @orders ||= orders
    @pagy, @orders = pagy @orders, items: params.fetch(:count, 10)

    @order = Order.new
    @order.build_order_content

    respond_to do |format|
      format.html
      format.csv { # give these formats a better home, shouldn't be in this controller or action
        send_data (Order.all).to_csv,
        filename: "Orders-#{(DateTime.now).try(:strftime,"%m/%d/%Y") }.csv",
        type: 'text/csv; charset=utf-8'
      }
      format.xls { # give these formats a better home, shouldn't be in this controller or action
        send_data (Order.all).to_csv,
        filename: "LightningMarineServices_Orders-#{(DateTime.now).try(:strftime,"%m/%d/%Y") }.xls"
      }
    end
  end

  # GET /vendors/new
  def new
    @vendor = Vendor.new
  end

  # GET /vendors/1/edit
  def edit
  end

  # POST /vendors or /vendors.json
  def create
    @vendor = Vendor.new(vendor_params)


    respond_to do |format|
      if @vendor.save
        format.html { redirect_to vendor_url(@vendor), notice: "Vendor was successfully created." }
        format.json { render :show, status: :created, location: @vendor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vendors/1 or /vendors/1.json
  def update
    respond_to do |format|
      if @vendor.update(vendor_params)
        format.html { redirect_to vendor_url(@vendor), notice: "Vendor was successfully updated." }
        format.json { render :show, status: :ok, location: @vendor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendors/1 or /vendors/1.json
  # def destroy
  #   @vendor.destroy
  #
  #   respond_to do |format|
  #     format.html { redirect_to vendors_url, notice: "Vendor was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end
  def destroy
    if @vendor.destroy
      redirect_to vendors_url, notice: "#{@vendor.name}(Vendor) deleted successfully."
    else
      redirect_to request.referrer
      # redirect_back fallback_location: orders_url
      @vendor.errors.full_messages.each.map {|message| flash[:alert] = message }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page_header_title
      @card_title = "Vendors"
    end

    def set_vendor
      @vendor = Vendor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vendor_params
      params.require(:vendor).permit(:name)
    end
end
