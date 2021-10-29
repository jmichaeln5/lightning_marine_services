module TableOptionKlass
  class TableOptionKlass
    attr_accessor :resource_table_type, :resource_table_action, :user, :controller_name_and_action

    def initialize(resource_table_type, resource_table_action, option_list, user, controller_name_and_action)

      @resource_table_type = resource_table_type
      @resource_table_action = resource_table_action
      @option_list = option_list
      @user = user
      @controller_name_and_action = controller_name_and_action
    end

    def resources_per_page
      10
    end

    def option_list
      TableOptionsHelper.default_table_options_for_form(controller_name_and_action)
    end

    def selected_options
      option_list
    end

    def belongs_to_user?
      false
    end

  end
end
