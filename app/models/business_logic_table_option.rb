class BusinessLogicTableOption

  attr_accessor :user, :resource_table

  def initialize(user, resource_table)
    @user = user
    @resource_table = resource_table
  end

  def order_table_options
    TableOptionsHelper.order_options_for_select_arr
  end

  def purchaser_table_options
    TableOptionsHelper.purchaser_options_for_select_arr
  end

  def vendor_table_options
    TableOptionsHelper.vendor_options_for_select_arr
  end

  def default_table_options
    TableOptionsHelper.default_table_options(@resource_table)
  end

  def get_table_option
    if @user.table_options.where(resource_table_type: @resource_table).first.present?
      ActiveSupport::JSON.decode(@user.table_options.where(resource_table_type: resource_table).first.option_list)
    else
      # get_table_options = order_table_options if @resource_table == 'Order'
      # get_table_options = purchaser_table_options if @resource_table == 'Purchaser'
      # get_table_options = vendor_table_options if @resource_table == 'Vendor'
      return default_table_options
    end
  end


  def selected_table_options
    if @user.table_options.where(resource_table_type: @resource_table).first.present?
        selected_table_options = Array.new
        active_options_arr = get_table_option.to_a

        order_table_options.map {|o| selected_table_options << o if active_options_arr.include? o[1] }

        selected_table_options
    else
      # Default Table Options
      # return order_table_options if @resource_table == 'Order'
      # return purchaser_table_options if @resource_table == 'Purchaser'
      # return vendor_table_options if @resource_table == 'Vendor'
        return default_table_options
    end
  end


end
