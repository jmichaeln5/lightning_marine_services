module ServiceManagerTableOption

  class HasTableOption
    def is_satisfied_by?(resource)
      # byebug
      # !resource.user.table_options.empty?

      # byebug

      !resource.user.table_options.where(resource_table_type: resource.controller_name, resource_table_action: resource.controller_action).empty?


      # resource_user_has_table_option = !resource.user.table_options.where(resource_table_type: resource.parent_class.to_s).empty?
      #
      # if resource_user_has_table_option == true
      #
      #   resource_parent_class = resource.parent_class.name.downcase.pluralize
      #   resource_controller_action = resource.controller_action
      #   resource_controller_name_and_action = "#{resource_parent_class}##{resource_controller_action}"
      #
      #   user_selected_table_options = resource.user.table_options.where(resource_table_type: resource.parent_class.to_s).first.selected_options
      #
      #   default_table_options = TableOptionsHelper.default_table_options_for_form(controller_name_and_action = resource_controller_name_and_action )
      #
      #   return false unless user_selected_table_options.in? default_table_options
      # end
    end
  end

  class IsIndexAction
    def is_satisfied_by?(resource)
      resource.controller_action == 'index' ? true : false
    end
  end

  class IsShowAction
    def is_satisfied_by?(resource)
      resource.controller_action == 'show' ? true : false
    end
  end

end
