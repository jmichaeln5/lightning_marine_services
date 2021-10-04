# class ResourceTableOption ############ Before Resource Parent Class
class ResourceTableOption < Resource
    attr_accessor :user, :resource, :action, :page

    def initialize(user, resource, action, page)
      @user = user
      @resource = resource
      @action = action
      @page = page
    end

    def controller_name_and_action
      "#{@resource}##{@action}".downcase
    end

    def table_options_present?
      if @user.table_options.where(resource_table_type: @resource.to_s).any?
        return true
      else
        return nil
      end
    end

    def table_options
      @table_options = @user.table_options.where(resource_table_type: @resource.to_s).first if table_options_present?
    end

    def resources_per_page
      table_options.resources_per_page ||= 10
    end

    # def total_pages
    #   # byebug
    # end

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

    def return_table_options
      # if @user.table_options.where(resource_table_type: @resource).first.option_list.present?
      if table_options_present? && table_options.option_list.present?
        # byebug
        # ActiveSupport::JSON.decode(table_options.option_list)
        table_options.option_list_arr
      else
        return default_table_options
      end
    end


  end
