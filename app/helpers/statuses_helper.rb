module StatusesHelper
  def valid_status?
    return false unless status_param?
    return @statusable.try(:statusable?) && @statusable.statuses[status_param[0]] == status_param[1].try(:to_i)
  end

  def statusable_order?
    @statusable.statusable_type == "Order"
  end

  def statusable_packaging_material?
    @statusable.statusable_type.include? "PackagingMaterial"
  end

  def statusable_on_orders_show?
    referrer_info = check_referrer
    referrer_info.controller == "orders" && referrer_info.action == "show"
  end

  def notice_msg
    "#{@statusable.model_name.human} status updated to #{status_name.humanize}"
  end

  def render_turbo_notice
    render turbo_stream: turbo_stream.replace(@statusable.statusable_dom_id, partial: "statuses/status",
      locals: {
        statusable: @statusable,
        status_badge_css: @status_badge_css,
        notice: notice_msg,
        })
  end

  def render_turbo_alert
    flash_title = "There was #{@statusable.errors.size} #{(@statusable.errors.size > 1) ? 'errors' : 'error'} with your submission:"
    render turbo_stream: turbo_stream.append('flashes', partial: "/layouts/stacked_shell/headings/flash_messages",
      locals: {
        flash_type: 'alert', flash_title: flash_title, flash_description: @statusable.errors.collect {|e| e.full_message }
      })
  end
end
