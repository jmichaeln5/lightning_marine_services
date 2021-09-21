class BusinessLogicTableOption

  attr_accessor :user, :resource_table, :default_table_options

  def initialize(user, resource_table, default_table_options = nil)
    @user = user
    @resource_table = resource_table
    @default_table_options ||= order_table_options
  end

  def get_table_option
    @user.table_options.where(resource_table_type: resource_table).first
  end

  def order_table_options
    order_table_options = ['Order ID', 'id'], ['Dept', 'dept'], ['Ship', 'ship_name'], ['Vendor', 'vendor_name'],  ['PO Number', 'po_number'], ['Date Received', 'date_recieved'], ['Order Content', 'order_content'], ['Courrier', 'courrier'], ['Date Delivered', 'date_delivered']
  end

  def sanatize_user_table_options
    ActiveSupport::JSON.decode(get_table_option.option_list)
  end

  def selected_table_options
    selected_table_options = Array.new
    active_options_arr = sanatize_user_table_options.to_a

    order_table_options.map {|o| selected_table_options << o if active_options_arr.include? o[1] }

    return selected_table_options

  end

end
