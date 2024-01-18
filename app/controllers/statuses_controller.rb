class StatusesController < ApplicationController
  before_action :set_statusable, only: %i(show edit update)

  def show
  end

  def edit
  end

  def update
    return nil unless (@statusable && @statusable.respond_to?(:statusable?))

    @statusable.update!(
      status: ((status_param.to_sym.in? @statusable.statuses) ? status_param.to_sym : @statusable.status)
    )
    notice_msg = "#{@statusable.model_name.human} status updated to #{@statusable.status}"

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@statusable.statusable_dom_id, partial: "statuses/status",
          locals: { statusable: @statusable, notice: notice_msg })
      end
      format.html { redirect_to @statusable, notice: notice_msg }
    end
  end

  private
    def statusable_params
      params.permit(
        :id,
        :statusable_id,
        :statusable_type,
        :status,
      )
    end

    def status_param
      statusable_params[:status]
    end

    def set_statusable
      statusable_id = statusable_params.fetch(:statusable_id, :id)
      @statusable = statusable_params[:statusable_type].safe_constantize.find(statusable_id)
    end
end
