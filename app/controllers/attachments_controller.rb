class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order

  # Fix in (bottom section in this post) https://gorails.com/forum/how-do-i-create-a-delete-button-for-images-uploaded-with-active-storage

  def destroy_attachment
    image = ActiveStorage::Attachment.find(params[:attachment_id])
    image.purge_later
    redirect_to request.referrer, notice: "Attachment deleted successfully."
  end

  private
    def set_order
      @order = Order.find(params[:order_id])
    end
end
