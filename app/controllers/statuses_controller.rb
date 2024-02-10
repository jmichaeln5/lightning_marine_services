class StatusesController < ApplicationController
  layout -> { "stacked_shell" if turbo_frame_request? }

  include StatusesHelper

  before_action :set_statusable, only: %i(show edit)

  def show
  end

  def edit
  end

  def update
    set_statusable if status_param?

    return false unless valid_status?

    if statusable_on_orders_show? and statusable_order?
      update_and_redirect_to(@statusable.statusable_path)
    else
      update_and_render_turbo_stream
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

    def set_statusable
      statusable_id = statusable_params.fetch(:statusable_id, :id)
      @statusable = statusable_params[:statusable_type].safe_constantize.find(statusable_id)
      @status_badge_css = statusable_params.fetch(:status_badge_css, "rounded-full")
    end

    def status_name
      status_param[0]
    end

    def update_and_redirect_to(path)
      respond_to do |format|
        if @statusable.update(status: status_name)
          format.turbo_stream do
            flash[:notice] = notice_msg
            render turbo_stream: turbo_stream.action(:redirect, path)
          end
        else
          format.turbo_stream do
            render_turbo_alert
          end
        end
      end
    end

    def update_and_render_turbo_stream
      respond_to do |format|
        if @statusable.update(status: status_name)
          format.turbo_stream do
            render_turbo_notice
          end
          format.html { redirect_to @statusable, notice: notice_msg }
        else
          format.turbo_stream do
            render_turbo_alert
          end
        end
      end
    end
end
