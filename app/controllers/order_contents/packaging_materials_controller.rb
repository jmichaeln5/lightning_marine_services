class OrderContents::PackagingMaterialsController < ApplicationController
  layout "stacked_shell"

  before_action :set_order_content, :set_order, only: %i[ index new create ]

  def index
    @packaging_materials = @order_content.packaging_materials
  end

  def new
    @packaging_material = packaging_material_scoped? ? build_from_scoped : @order_content.packaging_materials.build
  end

  def create
    packaging_material_klass = scope_packaging_material.constantize
    @packaging_material = packaging_material_klass.new packaging_material_params

    respond_to do |format|
      if @packaging_material.save
        format.html { redirect_to @order_content, notice: "Packaging material was successfully created." }
        format.json { render :show, status: :created, location: @order_content }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order_content.errors, status: :unprocessable_entity }
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

    def set_type
      case params[:type]
      when 'Box'
        'box'
      when 'Crate'
        'crate'
      when 'Pallet'
        'pallet'
      end
    end

    def packaging_material_scoped?
      valid_scopes = ['Box', 'Crate', 'Pallet']
      params[:type].in? valid_scopes
    end

    def build_from_scoped
      @order_content.packaging_materials

      attr_to_build = params[:type].downcase.pluralize
      build_type = @order_content.packaging_materials.send attr_to_build
      build_type.build
    end

    def scope_packaging_material
      # PackagingMaterial::Packageable::TYPES
      case params[:type]
      when 'Box'
        'PackagingMaterial::Box'
      when 'Crate'
        'PackagingMaterial::Crate'
      when 'Pallet'
        'PackagingMaterial::Pallet'
      else
        'PackagingMaterial'
      end
    end

    def get_scoped_subclass
      case params[:type]
      when 'Box'
        'PackagingMaterial::Box'
      when 'Crate'
        'PackagingMaterial::Crate'
      when 'Pallet'
        'PackagingMaterial::Pallet'
      end
    end

    def packaging_material_params
      if packaging_material_scoped?
        params.require("packaging_material_#{set_type}".to_sym).permit(
          :type,
          :description,
        ).with_defaults(order_content_id: @order_content.id)
      else
        params.require(:packaging_material).permit(
          :type,
          :description,
        ).with_defaults(order_content_id: @order_content.id)
      end
    end
end
