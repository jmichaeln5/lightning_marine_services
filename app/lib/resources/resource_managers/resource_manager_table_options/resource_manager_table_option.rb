autoload :IndepentTableOption, "services/table_options/independent_table_option.rb"

module ResourceManagerTableOption
  extend IndepentTableOption

  def self.new_table_option(user, parent_class, parent_action, page)
    user = user
    controller_name_and_action = "#{parent_class.name}##{parent_action}".downcase
    resource_table_type = parent_class.name
    option_list = TableOptionsHelper.default_table_options_for_form(controller_name_and_action)
    resources_per_page = 10

    return IndepentTableOption::TableOptionKlass.new(user = user, controller_name_and_action = controller_name_and_action, resource_table_type = parent_class.name, option_list = option_list, selected_options = option_list, resources_per_page = resources_per_page)
  end

  def self.user_table_option(user, parent_class, action, page)
    return user.table_options.where(resource_table_type: parent_class.name).first
  end

end
