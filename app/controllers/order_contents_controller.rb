class OrderContentsController < ApplicationController
  layout "stacked_shell"

  before_action :set_order_content, :set_order, :set_packaging_materials, only: %i[ show edit update destroy ]

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @order_content.update(order_content_params)
        format.html { redirect_to @order, notice: "Order content updated successfully." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order_content.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  private
    def set_order_content
      @order_content = OrderContent.find(params[:id])
    end

    def set_order
      @order = @order_content.order
    end

    def set_packaging_materials
      # @packaging_materials = @order_content.packaging_materials
      @packaging_materials = @order_content.packaging_materials.order(created_at: :desc)
    end

    def order_content_params
      params.require(:order_content).permit(
        :box, :crate, :pallet, :other, :other_description,
        # images: [],
        packaging_materials_attributes:[
          # :id, :box, :crate, :pallet, :other, :other_description
          :id, :type, :description, :_destroy,
        ]
      )
    end
end
