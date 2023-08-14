module TurboFlashable
  def turbo_render_flash(delay_value = nil, flash_type, flash_title, flash_description: nil)
    delay_value ||= 3000

    flash_partial_local_variables = {
      delay_value: delay_value,
      flash_type: flash_type,
      flash_title: flash_title,
      flash_description: flash_description,
    }

    turbo_stream.append(
      'flashes',
      partial: "/layouts/stacked_shell/headings/flash_messages",
      locals: flash_partial_local_variables
    )
  end
end
