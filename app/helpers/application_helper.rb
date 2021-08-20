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
    controller_name == 'purchasers' ? 'ships' : "#{controller_name}"
  end

  def current_action
    current_page = "#{action_name}"
  end

  def main_functionality_controller?
    ['purchasers', 'ships', 'vendors', 'orders', 'order_contents'].include? current_controller
  end

  def show_create_order_on_purchaser_and_order?
    if ((current_page == 'purchasers#show' ) || (current_page == 'vendors#show'))
      true
    else
      nil
    end
  end

  # Used in app/views/layouts/_edit_toggle.html.erb to get Model Instance on #show action
  def get_resource_instance(controller_name)
    if (main_functionality_controller? == true) && (action_name == 'show')
      klass = Object.const_get "#{controller_name.singularize.capitalize}"
      klass.find(params[:id])
    end
  end

end
