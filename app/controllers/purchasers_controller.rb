class PurchasersController < ApplicationController
  layout "stacked_shell"

  before_action :authorize_internal_user, only: %i[ new create edit update destroy ]
  before_action :set_page_heading_title, except: %i[ show ]
  before_action :set_purchaser, only: %i[ show edit update destroy export ]

  def index
    @purchasers = Purchaser.all
    sort_purchasers if params[:sort]
    @pagy, @purchasers = pagy @purchasers, items: params.fetch(:count, 10)
  end

  def sort_column
    %w{ id name order_amount }.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w{ asc desc }.include?(params[:direction]) ? params[:direction] : "asc"
  end

  def sort_purchasers
    if params[:sort] == "order_amount"
      Purchaser.left_joins(:orders).group(:id).reorder("COUNT(orders.id) #{sort_direction}")
      @purchasers = nil
      purchasers = Purchaser.left_joins(:orders).group(:id).reorder("COUNT(orders.id) #{sort_direction}")
    else
      purchasers = @purchasers.reorder(sort_column => sort_direction) if %w{ id name order_amount }.include?(params[:sort])
      @purchasers = nil
    end
    clear_active_record_query_cache
    @purchasers = purchasers
  end

  def show
    @page_heading_title = "Ship"

    orders = Order.unarchived.where(purchaser: @purchaser)

    if params[:query].present?
      query_str = params[:query]
      results = orders.search(query_str, misspellings: {below: 3}).results
      results_arr = Array.new
      results.each do |result|
        results_arr << result.id if (result.archived? == false)
      end
      @orders = nil
      orders = Order.unarchived.where(purchaser: @purchaser).reorder('id ASC')
      orders = orders.where(id: results_arr)
    end

    if params[:sort]
      sort_col = %w{ id dept date_recieved courrier date_delivered }.include?(params[:sort]) ? params[:sort] : "id"
      sort_dir = %w{ asc desc }.include?(params[:direction]) ? params[:direction] : "asc"

      if ((params[:sort] == "ship_name") || ( params[:sort] == "purchaser_name" )) # None Order col
        sorted_orders = Order.where(id: orders.ids).filter_by_purchasers(sort_dir) if params[:sort] == "ship_name"
        sorted_orders = Order.where(id: orders.ids).filter_by_purchasers(sort_dir) if params[:sort] == "purchaser_name"
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

      if ((params[:sort] != "ship_name") && ( params[:sort] != "purchaser_name" )) # Order col
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

  def new
    @purchaser = Purchaser.new
  end

  def edit
  end

  def create
    @purchaser = Purchaser.new(purchaser_params)

    respond_to do |format|
      if @purchaser.save
        format.html { redirect_to @purchaser, notice: "Ship was successfully created." }
        format.json { render :show, status: :created, location: @purchaser }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @purchaser.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @purchaser.update(purchaser_params)
        format.html { redirect_to purchaser_url(@purchaser), notice: "Ship was successfully updated." }
        format.json { render :show, status: :ok, location: @purchaser }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @purchaser.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @purchaser.destroy
      redirect_to purchasers_url, notice: "#{@purchaser.name}(Ship) deleted successfully."
    else
      redirect_to request.referrer
      @purchaser.errors.full_messages.each.map {|message| flash[:alert] = message }
    end
  end

  def export
    filePrefix = (@purchaser.name + "_").parameterize(separator: '_')
    @orders = @purchaser.orders.unarchived
    respond_to do |format|
      format.html {
        render :export }
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
    def set_page_heading_title
      @page_heading_title = "Ships"
    end

    def set_purchaser
      @purchaser = Purchaser.find(params[:id])
    end

    def purchaser_params
      params.require(:purchaser).permit(:name)
    end
end
