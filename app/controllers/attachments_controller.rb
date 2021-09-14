class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order

# Issue (Original)
  # def delete_image_attachment
  #   @order_image = ActiveStorage::Blob.find_signed(params[:id])
  #   @order_image.purge_later
  #   redirect_to request.referrer, notice: "Image deleted successfully."
  # end

# "Fixed" (bottom section in this post) https://gorails.com/forum/how-do-i-create-a-delete-button-for-images-uploaded-with-active-storage


  def destroy_attachment
    # byebug
    image = ActiveStorage::Attachment.find(params[:attachment_id])
    image.purge_later
    redirect_to request.referrer, notice: "Attachment deleted successfully."
  end


  # def destroy
  #   byebug
  #   image = ActiveStorage::Attachment.find(params[:id])
  #   image.purge_later
  #   redirect_to request.referrer, notice: "Image deleted successfully."
  # end



  private
    def set_order
      @order = Order.find(params[:order_id])
    end
end
