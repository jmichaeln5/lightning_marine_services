class OrderContents::PackagingMaterialsController < ApplicationController
  layout "stacked_shell"

  before_action :set_order_content, :set_order, only: %i[ index new create ]

  def index
    packaging_materials =
      if packaging_material_scoped?
        @order_content.packaging_materials.where(type: "PackagingMaterial::#{type_param}")
      else
        @order_content.packaging_materials
      end
    @packaging_materials = packaging_materials.order(created_at: :desc)
  end

  def new
    @packaging_material = packaging_material_scoped? ? build_from_scoped : @order_content.packaging_materials.build
  end

  def create
    @packaging_material = PackagingMaterial.new packaging_material_params

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
    def type_param
      (params[:type].in? PackagingMaterial.humanized_types) ? params[:type] : PackagingMaterial::Packageable::TYPES
    end

    def packaging_material_scoped?
      params[:type].in? PackagingMaterial.humanized_types
    end

    def set_order_content
      @order_content = OrderContent.find(params[:order_content_id])
    end

    def set_order
      @order = @order_content.order
    end

    def build_from_scoped
      @order_content.packaging_materials

      attr_to_build = params[:type].downcase.pluralize
      build_type = @order_content.packaging_materials.send attr_to_build
      build_type.build
    end

    def scope_packaging_material
      case params[:type]
      when 'Box'
        'PackagingMaterial::Box'
      when 'Crate'
        'PackagingMaterial::Crate'
      when 'Pallet'
        'PackagingMaterial::Pallet'
      else 'Other'
        'PackagingMaterial::Other'
      end
    end

    def packaging_material_params
      packaging_material_from_param = "packaging_material"
      if packaging_material_scoped?
        packaging_material_from_param << "_#{type_param.downcase}"
        params.require(packaging_material_from_param.to_sym).permit(
          :type,
          :description,
        ).with_defaults(
          order_content_id: @order_content.id,
          type: scope_packaging_material,
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
