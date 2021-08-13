# class OrderContentsController < ApplicationController
#   before_action :set_order_content, only: %i[ show edit update destroy ]
#
#   # GET /order_contents or /order_contents.json
#   def index
#     @order_contents = OrderContent.all
#   end
#
#   # GET /order_contents/1 or /order_contents/1.json
#   def show
#   end
#
#   # GET /order_contents/new
#   def new
#     @order_content = OrderContent.new
#   end
#
#   # GET /order_contents/1/edit
#   def edit
#   end
#
#   # POST /order_contents or /order_contents.json
#   def create
#     @order_content = OrderContent.new(order_content_params)
#
#     respond_to do |format|
#       if @order_content.save
#         format.html { redirect_to @order_content, notice: "Order content was successfully created." }
#         format.json { render :show, status: :created, location: @order_content }
#       else
#         format.html { render :new, status: :unprocessable_entity }
#         format.json { render json: @order_content.errors, status: :unprocessable_entity }
#       end
#     end
#   end
#
#   # PATCH/PUT /order_contents/1 or /order_contents/1.json
#   def update
#     respond_to do |format|
#       if @order_content.update(order_content_params)
#         format.html { redirect_to @order_content, notice: "Order content was successfully updated." }
#         format.json { render :show, status: :ok, location: @order_content }
#       else
#         format.html { render :edit, status: :unprocessable_entity }
#         format.json { render json: @order_content.errors, status: :unprocessable_entity }
#       end
#     end
#   end
#
#   # DELETE /order_contents/1 or /order_contents/1.json
#   def destroy
#     @order_content.destroy
#     respond_to do |format|
#       format.html { redirect_to order_contents_url, notice: "Order content was successfully destroyed." }
#       format.json { head :no_content }
#     end
#   end
#
#   private
#     # Use callbacks to share common setup or constraints between actions.
#     def set_order_content
#       @order_content = OrderContent.find(params[:id])
#     end
#
#     # Only allow a list of trusted parameters through.
#     def order_content_params
#       params.require(:order_content).permit(:box, :crate, :pallet, :other, :other_description, :order_id)
#     end
# end
