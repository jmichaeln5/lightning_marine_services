class Orders::OrderContentsController < ApplicationController
  layout "stacked_shell"

  def create
  end

  private
    def order_params
      params.require(:order_content).permit(
        :id, :box, :crate, :pallet, :other, :other_description,
        # images: [],
        packaging_materials_attributes:[
          # :id, :box, :crate, :pallet, :other, :other_description
          :type, :description,
        ]
      )
    end

    def set_order
      @order = Order.find(params[:order_id])
    end

    def set_order_content
      @order_content = @order.order_content
      @order_content ||= @order.build_order_content
    end

    def set_order_content_packaging_materials
      @packaging_materials = @order_content.packaging_materials
    end
end
