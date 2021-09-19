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

  def show_on_order_ship_purchaser_pages?
    ['purchasers', 'ships', 'vendors', 'orders', 'order_contents'].include? current_controller
  end

  def show_create_order_on_purchaser_and_vendor?
    if ((current_page == 'purchasers#show' ) || (current_page == 'vendors#show'))
      true
    else
      nil
    end
  end

  def index_action_purchaser_and_vendor?
    if ((current_page == 'purchasers#index' ) || (current_page == 'vendors#index'))
      true
    else
      nil
    end
  end

  def get_resource(controller_name)
    if (show_on_order_ship_purchaser_pages? == true)
      klass = Object.const_get "#{controller_name.singularize.capitalize}"
    end
  end

  # Used in app/views/layouts/_edit_toggle.html.erb to get Model Instance on #show action (reason for instansiatied class to be found by params[:id] )
  def get_resource_instance(controller_name)
      if (show_on_order_ship_purchaser_pages? == true)
        get_resource(controller_name).find(params[:id])
      end
  end

  def current_url(new_params)
  end

  # def run_as_sql(arg = nil)
  #   arg ||= nil
  #   ActiveRecord::Base.connection.execute(arg.to_s)
  # end

  def main_controllers
    main_controllers = ["orders", "purchasers", "vendors"]
  end

end
