module ApplicationHelper
  include Pagy::Frontend

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

  def status_badge(status, options = nil)
    case status
    when "active"
      default_badge_options = "badge badge-green"
    when "partially_delivered"
      default_badge_options = "badge badge-yellow"
    when "hold"
      default_badge_options = "badge badge-purple"
    when "delivered"
      default_badge_options = "badge badge-gray"
    else
      default_badge_options = "inline-flex items-center rounded-full px-2 py-1 text-xs font-medium ring-1 ring-inset ring-gray-300 text-gray-400 font-semibold"
    end
    tag.span(status.humanize, class: "lowercase #{default_badge_options} #{options}")
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
end
