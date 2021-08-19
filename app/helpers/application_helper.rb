module ApplicationHelper

  def is_nil_and_zero(data)
     data.blank? || data == 0
  end

  def locale_to
    @locale_to = "#{controller_name.capitalize}##{action_name}"
  end

  def current_page
    current_page = "#{controller_name}##{action_name}"
  end

  def current_controller
    # current_page = "#{controller_name}"
    controller_name == 'purchasers' ? 'ships' : "#{controller_name}"
  end

  def current_action
    current_page = "#{action_name}"
  end

  def main_functionality_controller?
    ['purchasers', 'ships', 'vendors', 'orders', 'order_contents'].include? current_controller
  end

end
