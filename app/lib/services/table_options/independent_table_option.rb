# NOT ACTIVE RECORD TABLE OPTION
# NOT ACTIVE RECORD TABLE OPTION
# NOT ACTIVE RECORD TABLE OPTION
module IndepentTableOption

class TableOptionKlass
    attr_accessor :user, :controller_name_and_action, :resource_table_type, :option_list, :selected_options, :resources_per_page

    def initialize(user, controller_name_and_action, resource_table_type, option_list, selected_options, resources_per_page)

      @user = user
      @controller_name_and_action = controller_name_and_action
      @resource_table_type = resource_table_type
      @option_list = option_list
      @selected_options = selected_options
      @resources_per_page = resources_per_page
    end

    def resources_per_page
      10
    end

    def default_table_options
      TableOptionsHelper.default_table_options_for_form(controller_name_and_action)
    end

  end
end
