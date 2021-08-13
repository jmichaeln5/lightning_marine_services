class PurchasersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_purchaser, only: %i[ show edit update destroy ]

  # GET /purchasers or /purchasers.json
  def index
    @purchasers = Purchaser.all.order("created_at DESC")
  end

  # GET /purchasers/1 or /purchasers/1.json
  def show
  end

  # GET /purchasers/new
  def new
    @purchaser = Purchaser.new
  end

  # GET /purchasers/1/edit
  def edit
  end

  def create
    @purchaser = Purchaser.new(purchaser_params)
    if @purchaser.save
      # Notification.create(recipient: @purchaser.receiver, actor: @purchaser.requestor, action:'test_action', notifiable: @purchaser )
      redirect_to request.referrer, notice: "Purchaser created successfully."
    else
      redirect_to request.referrer
      @purchaser.errors.full_messages.each.map {|message| flash[:alert] = message }
    end
  end

  # PATCH/PUT /purchasers/1 or /purchasers/1.json
  def update
    if @purchaser.update(purchaser_params)
      redirect_to request.referrer, notice: "Purchaser updated successfully."
    else
      redirect_to request.referrer
      @purchaser.errors.full_messages.each.map {|message| flash[:alert] = message }
    end
  end

  # DELETE /purchasers/1 or /purchasers/1.json
  def destroy
    @purchaser.destroy
    respond_to do |format|
      format.html { redirect_to purchasers_url, notice: "Purchaser was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchaser
      @purchaser = Purchaser.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def purchaser_params
      params.require(:purchaser).permit(:name)
    end
end
