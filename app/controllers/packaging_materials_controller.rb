class PackagingMaterialsController < ApplicationController
  layout "stacked_shell"

  before_action :set_packaging_material, :set_order_content, :set_order, only: %i[ show edit update destroy ]

  def edit
  end

  def update
    respond_to do |format|
      if @packaging_material.update(type: type_param, description: packaging_material_params[:description])
        format.html { redirect_to @order_content, notice: "Packaging material updated successfully." }
        format.json { render :show, status: :created, location: @order_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order_content.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_packaging_material
      @packaging_material = PackagingMaterial.find(params[:id])
    end

    def set_order_content
      @order_content = @packaging_material.order_content
    end

    def set_order
      @order = @order_content.order
    end

    def type_param
      (packaging_material_params[:type].in? PackagingMaterial::Packageable::TYPES) ? packaging_material_params[:type] : 'PackagingMaterial'
    end

    def packaging_material_params
      params.require(:packaging_material).permit(:type, :description)
    end
end
