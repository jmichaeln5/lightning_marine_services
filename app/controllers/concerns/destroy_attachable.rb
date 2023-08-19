module DestroyAttachable
  def destroy_attachment
    blob = ActiveStorage::Blob.find_signed(params[:signed_id])
    blob_id = blob.id
    @attachment = ActiveStorage::Attachment.find_by(blob_id: blob_id)

    respond_to do |format|
      @attachment.purge
      resource_instance = controller_name.singularize.classify.constantize.find params[:id]
      attachments_count = resource_instance.images.count if resource_instance.respond_to? :images
      attachments_count_msg = ((attachments_count == 0) || (attachments_count > 1)) ? "#{attachments_count} Attachments" : "#{attachments_count} Attachment"

      format.turbo_stream {
        render turbo_stream: [
          turbo_render_flash(
            delay_value = 3000,
            flash_type = "notice",
            flash_title = "Attachment deleted successfully.",
          ),
          turbo_stream.update("attachment_count", attachments_count_msg),
          turbo_stream.remove("attachment_#{@attachment.signed_id}"),
        ], status: :ok
      }
    end
  end
end
