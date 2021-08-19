class VendorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vendor, only: %i[ show edit update destroy ]

  # GET /vendors or /vendors.json
  def index
    @vendors = Vendor.all.order("created_at DESC")
  end

  # GET /vendors/1 or /vendors/1.json
  def show
    @orders = Order.all.where(vendor_id: @vendor.id).order("created_at DESC")
  end

  # GET /vendors/new
  def new
    @vendor = Vendor.new
    # @purchaser = Purchaser.find(params[:purchaser_id])

  end

  # GET /vendors/1/edit
  def edit
  end

  # POST /vendors or /vendors.json
  def create
    @vendor = Vendor.new(vendor_params)
    if @vendor.save
      # Notification.create(recipient: @vendor.receiver, actor: @vendor.requestor, action:'test_action', notifiable: @vendor )
      redirect_to request.referrer, notice: "Vendor created successfully."
    else
      redirect_to request.referrer
      @vendor.errors.full_messages.each.map {|message| flash[:alert] = message }
    end
  end

  # PATCH/PUT /vendors/1 or /vendors/1.json
  def update
    if @vendor.update(vendor_params)
      redirect_to request.referrer, notice: "Vendor updated successfully."
    else
      redirect_to request.referrer
      @vendor.errors.full_messages.each.map {|message| flash[:alert] = message }
    end
  end

  # DELETE /vendors/1 or /vendors/1.json
  def destroy
    @vendor.destroy
    respond_to do |format|
      format.html { redirect_to vendors_url, notice: "Vendor was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vendor
      @vendor = Vendor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vendor_params
      params.require(:vendor).permit(:name)
    end
end
