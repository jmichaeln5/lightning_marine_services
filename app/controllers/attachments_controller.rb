class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order

  def delete_image_attachment
    @order_image = ActiveStorage::Blob.find_signed(params[:id])
    @order_image.purge_later
    redirect_to request.referrer, notice: "Image deleted successfully."
  end


  private
    def set_order
      @order = Order.find(params[:id])
    end
end
