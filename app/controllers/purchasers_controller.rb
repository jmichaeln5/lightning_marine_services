class PurchasersController < ApplicationController
  layout "stacked_shell"

  before_action :authorize_internal_user, only: %i[ new create edit update destroy ]
  before_action :set_page_heading_title
  before_action :set_purchaser, only: %i[ show edit update destroy]

  def index
    @purchasers = Purchaser.includes(:orders)
     .left_joins(:orders)
     .group(:id)
     .reorder("COUNT(orders.id) DESC")
    @purchasers = sort_resource if params[:sort]
    @pagy, @purchasers = pagy @purchasers, items: params.fetch(:count, 10)
  end

  def sort_resource
    sortable_scope = controller_name.classify
    controller_resource_klass = controller_name.classify.safe_constantize

    if controller_resource_klass.try(:sortable?) && controller_resource_klass.send(:sortable?)
      sort_column = controller_resource_klass.send(:sortable_attribute_names).include?(params[:sort]) ? params[:sort] : 'id'
      sort_direction = %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'

      return controller_resource_klass.send(:order_by_sortable_attribute_name, sort_column, sort_direction)
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
        format.html { redirect_to purchaser_orders_path(@purchaser), notice: "Ship created successfully." }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @purchaser.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @purchaser.update(purchaser_params)
        format.html { redirect_to purchaser_orders_path(@purchaser), notice: "Ship updated successfully." }
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
