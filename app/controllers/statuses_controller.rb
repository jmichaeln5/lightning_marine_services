class StatusesController < ApplicationController
  before_action :set_statusable, only: %i(show edit)

  def show
  end

  def edit
  end

  def update
    set_statusable if status_param?

    return false unless valid_status?

    respond_to do |format|
      if @statusable.update(status: status_name)
        notice_msg = "#{@statusable.model_name.human} status updated to #{status_name.humanize}"
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@statusable.statusable_dom_id, partial: "statuses/status",
            locals: {
              statusable: @statusable,
              status_badge_css: @status_badge_css,
              notice: notice_msg,
              })
        end
        format.html { redirect_to @statusable, notice: notice_msg }
      else
        format.turbo_stream do
          title = "There was #{@statusable.errors.size} #{(@statusable.errors.size > 1) ? 'errors' : 'error'} with your submission:"
          render turbo_stream: turbo_stream.append('flashes', partial: "/layouts/stacked_shell/headings/flash_messages",
            locals: {
              flash_type: 'alert', flash_title: title, flash_description: @statusable.errors.collect {|e| e.full_message }
            })
        end
      end
    end
  end

  private
    def statusable_params
      params.permit(
        :id,
        :statusable_id,
        :statusable_type,
        :status_badge_css,
        status:[],
      )
    end

    def status_param
      statusable_params[:status]
    end

    def status_param?
      !params[:status].blank?
    end

    def valid_status?
      return false unless status_param?
      return @statusable.try(:statusable?) && @statusable.statuses[status_param[0]] == status_param[1].try(:to_i)
    end

    def set_statusable
      statusable_id = statusable_params.fetch(:statusable_id, :id)
      @statusable = statusable_params[:statusable_type].safe_constantize.find(statusable_id)
      @status_badge_css = statusable_params.fetch(:status_badge_css, "rounded-full")
    end

    def status_name
      status_param[0]
    end
end
