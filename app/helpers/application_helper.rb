module ApplicationHelper
  include Pagy::Frontend

  def dev_output_str(str)
    return unless Rails.env == "development"
    puts (" \n")*5
    puts ("*"*50 + "\n")*5
    puts (" #{str} \n")*5
    puts ("*"*50 + "\n")*5
    puts (" \n")*5
  end

  def default_link_to_css_classes
    "font-medium hover:underline text-indigo-600 hover:text-indigo-800 hover:cursor-pointer"
  end

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
    customer = ["Client", "bg-green-100"]
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

  def controller_name_and_action
      "#{controller_name}##{action_name}"
  end

  def current_action
    "#{action_name}"
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

  def active_or_inactive_css(path:, active_css:, inactive_css:)
    # if current_page?(path)
    #   active_css
    # end
    current_page?(path) ? active_css : inactive_css
  end
end
