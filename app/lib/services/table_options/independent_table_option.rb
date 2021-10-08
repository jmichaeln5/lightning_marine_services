# NOT ACTIVE RECORD TABLE OPTION
# NOT ACTIVE RECORD TABLE OPTION
# NOT ACTIVE RECORD TABLE OPTION
module IndepentTableOption

class TableOptionKlass
    attr_accessor :user, :parent_class, :parent_action, :page

    def initialize(user, parent_class, parent_action, page)
      @user = user
      @parent_class = parent_class
      @parent_action = parent_action
      @page = page
    end

    def controller_name_and_action
      "#{@parent_class}##{@parent_action}".downcase
    end

    def table_options_present?
      if @user.table_options.where(resource_table_type: @parent_class.to_s).any?
        return true
      else
        return false
      end
    end

    def table_options
      @table_options = @user.table_options.where(resource_table_type: @parent_class.to_s).first if table_options_present?
    end

    def resources_per_page
      if table_options_present?
        table_options.resources_per_page
      else
        10
      end
    end

    def order_table_options
      TableOptionsHelper.order_options_for_select_arr
    end

    def purchaser_table_index_options
      TableOptionsHelper.purchaser_index_options_for_select_arr if @parent_action == 'index'
    end

    def purchaser_table_show_options
      TableOptionsHelper.purchaser_show_options_for_select_arr if @parent_action == 'show'
    end

    def vendor_table_index_options
      TableOptionsHelper.vendor_index_options_for_select_arr if @parent_action == 'index'
    end

    def vendor_table_show_options
      TableOptionsHelper.vendor_show_options_for_select_arr if @parent_action == 'show'
    end

    def default_table_options
      TableOptionsHelper.default_table_options_for_form(controller_name_and_action)
    end

    def return_table_options
      if table_options_present? && table_options.option_list.present?
        # byebug
        # ActiveSupport::JSON.decode(table_options.option_list)
        table_options.option_list_arr
      else
        return default_table_options
      end
    end

  end
end
