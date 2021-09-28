# class ResourceTableOption ############ Before Resource Parent Class
class ResourceTableOption < Resource
    attr_accessor :user, :resource

    def initialize(user, resource, action)
      @user = user
      @resource = resource
      @action = action
    end

    def controller_name_and_action
      "#{@resource}##{@action}".downcase
    end


    def table_option_present?
      if @user.table_options.where(resource_table_type: @resource).any?
        @table_option = @user.table_options.where(resource_table_type: @resource).first
      else
        return false
      end
    end

    def resources_per_page
      if table_option_present?
        return @table_option.resources_per_page
      else
        return 10
      end
    end

    def order_table_options
      TableOptionsHelper.order_options_for_select_arr
    end

    def purchaser_table_index_options
      TableOptionsHelper.purchaser_index_options_for_select_arr if @action == 'index'
    end

    def purchaser_table_show_options
      TableOptionsHelper.purchaser_show_options_for_select_arr if @action == 'show'
    end

    def vendor_table_index_options
      TableOptionsHelper.vendor_index_options_for_select_arr if @action == 'index'
    end

    def vendor_table_show_options
      TableOptionsHelper.vendor_show_options_for_select_arr if @action == 'show'
    end

    def default_table_options
      TableOptionsHelper.default_table_options_for_form(controller_name_and_action)
    end

    def get_table_option
      # if @user.table_options.where(resource_table_type: @resource).first.option_list.present?
      if table_option_present? && @table_option.option_list.present?
        ActiveSupport::JSON.decode(@user.table_options.where(resource_table_type: resource).first.option_list)
      else
        return default_table_options
      end
    end

    def selected_table_options
      # if @user.table_options.where(resource_table_type: @resource).first.present?
      if table_option_present? && @table_option.option_list.present?
          selected_table_options = Array.new
          active_options_arr = get_table_option.to_a

          order_table_options.map {|o| selected_table_options << o if active_options_arr.include? o[1] }

          selected_table_options
      else
          return default_table_options
          # controller_name_and_action = "#{@resource}##{@action}".downcase
          # return TableOptionsHelper.default_table_options_for_form.send(controller_name_and_action)

      end
    end

  end
