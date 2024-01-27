class OrderContents::PackagingMaterialsController < ApplicationController
  layout "stacked_shell"

  before_action :set_order_content, :set_order, only: %i[ index new create ]

  def index
    packaging_materials =
      if packaging_material_scoped?
        index_types = (params[:type].in? PackagingMaterial::Packageable::TYPE_NAMES) ? params[:type] : PackagingMaterial::Packageable::TYPES
        index_scoped_types = "PackagingMaterial::#{index_types}"

        @order_content.packaging_materials.where(type: index_scoped_types)
      else
        @order_content.packaging_materials
      end
    @packaging_materials = packaging_materials.order(created_at: :desc)
  end

  def new
    if packaging_material_scoped?
      new_scoped_type = ((params[:type].in? PackagingMaterial::Packageable::TYPE_NAMES) ? "PackagingMaterial::#{params[:type]}" : 'PackagingMaterial::Other')

      @packaging_material = PackagingMaterial.new(
        order_content: @order_content,
        type: new_scoped_type,
      )
    else
      @packaging_material = @order_content.packaging_materials.build
    end
  end

  def create
    @packaging_material = PackagingMaterial.new(
      order_content: @order_content,
      type: ((packaging_material_params[:type].in? PackagingMaterial::Packageable::TYPES) ? packaging_material_params[:type] : 'PackagingMaterial::Other'),
      description: packaging_material_params[:description],
    )

    respond_to do |format|
      if @packaging_material.save
        format.html { redirect_to @order, notice: "Packaging material was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_order_content
      @order_content = OrderContent.find(params[:order_content_id])
    end

    def set_order
      @order = @order_content.order
    end

    def packaging_material_scoped?
      params[:type].in? PackagingMaterial::Packageable::TYPE_NAMES
    end

    def packaging_material_params
      packaging_material_from_param = "packaging_material"

      if packaging_material_scoped?
        packaging_material_type_from_params = (params[:type].in? PackagingMaterial::Packageable::TYPE_NAMES) ? params[:type] : 'Other'
        packaging_material_from_param << "_#{packaging_material_type_from_params.downcase}"

        params.require(packaging_material_from_param.to_sym).permit(
          :type,
          :description,
        ).with_defaults(
          order_content_id: @order_content.id,
          type: packaging_material_type_from_params,
        )
      else
        params.require(packaging_material_from_param.to_sym).permit(
          :type,
          :description,
        ).with_defaults(
          order_content_id: @order_content.id,
        )
      end
    end
end
