module ApplicationHelper
  include Pagy::Frontend

  def sort_link_to(name, column, **options)
    if params[:sort] == column.to_s
      direction = params[:direction] == "asc" ? "desc" : "asc"
    else
      direction = "asc"
    end

    link_to name, request.params.merge(sort: column, direction: direction), **options
  end

  def user_badge
    visitor = ["Visitor", "bg-gray-100"]
    customer = ["Customer", "bg-green-100"]
    staff = ["Staff", "bg-blue-100"]
    admin = ["Admin", "bg-purple-100"]

    if !current_user
      kurrent_user_badge = visitor
    else
      kurrent_user_badge = staff if current_user.has_role?('staff')
      kurrent_user_badge = admin if current_user.has_role?('admin')
      kurrent_user_badge = customer if current_user.has_role?('customer')
    end

    return content_tag( :span, kurrent_user_badge[0], class:"inline-flex items-center rounded-full #{kurrent_user_badge[1]} px-3 py-1 text-xs font-medium text-gray-800")
  end


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

  def display_header_content?
    ['purchasers', 'ships', 'vendors', 'orders', 'order_contents', 'registrations', 'dashboard'].include? current_controller
  end


  def display_edit_toggle?
    (['purchasers', 'ships', 'vendors', 'orders', 'order_contents'].include? current_controller) and (current_action == 'show')
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

end
