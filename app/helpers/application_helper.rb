module ApplicationHelper

  def is_nil_and_zero(data)
     data.blank? || data == 0
  end

  def main_controllers
    main_controllers = ["orders", "purchasers", "vendors", "table_options"]
  end

  def controller_name_and_action
      "#{controller_name}##{action_name}"
  end

  def current_controller
    controller_name == 'purchasers' ? 'ships' : "#{controller_name}"
  end

  def current_action
    "#{action_name}"
  end

  def display_on_orders_purchasers_vendors?
    ['purchasers', 'ships', 'vendors', 'orders', 'order_contents'].include? current_controller
  end

  def display_create_order_on_purchaser_and_vendor_views?
    if ((controller_name_and_action == 'purchasers#show' ) || (controller_name_and_action == 'vendors#show'))
      true
    else
      false
    end
  end

  def display_on_index_action_for_purchaser_and_vendor?
    if ((controller_name_and_action == 'purchasers#index' ) || (controller_name_and_action == 'vendors#index'))
      true
    else
      false
    end
  end

  def display_on_order_show?
    if (controller_name_and_action == 'orders#show' )
      true
    else
      false
    end
  end

  def get_resource(controller_name)
      klass = Object.const_get "#{controller_name.singularize.capitalize}"
  end

  # Used in app/views/layouts/_edit_toggle.html.erb to get Model Instance on #show action (reason for instansiatied class to be found by params[:id] )
  def get_resource_instance(controller_name)
      if (display_on_orders_purchasers_vendors? == true)
        get_resource(controller_name).find(params[:id])
      end
  end

  def clear_cache_for_services
    Rails.cache.clear

    puts " "
    puts " "
    puts "*"*20
    puts "*"*20
    puts " "
    puts "Cache cleared successfully."
    puts " "
    puts "*"*20
    puts "*"*20
    puts " "
    puts " "
    puts " "
  end

end
