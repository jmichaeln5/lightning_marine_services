class PackagingMaterialsController < ApplicationController
  layout "stacked_shell"

  before_action :set_packaging_material, :set_order_content, :set_order, only: %i[ edit update destroy ]

  def new
    params.permit(:type, :target)
    @type = (params[:type].in? PackagingMaterial::Packageable::TYPES) ? params[:type] : 'PackagingMaterial::Other'
    @target = params[:target]
  end

  def edit
  end

  def update
    respond_to do |format|
      if @packaging_material.update(type: type_param, description: packaging_material_params[:description])
        format.html { redirect_to @order, notice: "Packaging material updated successfully." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order_content.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @packaging_material.destroy

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.remove(@packaging_material),
          turbo_render_flash(delay_value = nil,  flash_type = "notice", flash_title = "Packaging material (#{@packaging_material.type_name.downcase}) destroyed successfully.")
        ],
        status: :ok
      }
      format.html { redirect_to people_url, notice: "Packaging material was successfully destroyed." }
      format.json { head :no_content }
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
      (packaging_material_params[:type].in? PackagingMaterial::Packageable::TYPES) ? packaging_material_params[:type] : 'PackagingMaterial::Other'
    end

    def packaging_material_params
      params.require(:packaging_material).permit(:type, :description)
    end
end
