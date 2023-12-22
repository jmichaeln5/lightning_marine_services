class Orders::OrderContentsController < ApplicationController
  layout "stacked_shell"

  def create
  end

  # # has_many # parent building new child
  # @book = @author.books.build(
  #   published_at: Time.now,
  #   book_number: "A12345"
  # )
  #
  # # has_many # child building new parent
  # @author = @book.build_author(
  #   author_number: 123,
  #   author_name: "John Doe"
  # )

  private
    # def order_params
    #   params.require(:order).permit(
    #     :dept, :po_number, :tracking_number, :date_recieved, :courrier, :date_delivered, :purchaser_id, :vendor_id, :order_sequence,
    #     images: [],
    #     order_content_attributes:[
    #       :id, :box, :crate, :pallet, :other, :other_description
    #     ]
    #   )
    # end
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
