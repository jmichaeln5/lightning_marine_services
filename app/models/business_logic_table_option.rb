class BusinessLogicTableOption

  attr_accessor :user, :resource_table, :default_table_options

  def initialize(user, resource_table, default_table_options = nil)
    @user = user
    @resource_table = resource_table
    @default_table_options ||= order_table_options
  end

  def order_table_options
    order_table_options = ['Order ID', 'id'], ['Dept', 'dept'], ['Ship', 'ship_name'], ['Vendor', 'vendor_name'], ['PO Number', 'po_number'], ['Date Received', 'date_recieved'], ['Order Content', 'order_content'], ['Courrier', 'courrier'], ['Date Delivered', 'date_delivered']
  end

  def purchaser_table_options
    purchaser_table_options = ["Order ID","id"], ['Dept', 'dept'], ['Vendor', 'vendor_name'], ['PO Number', 'po_number'], ['Date Received', 'date_recieved'], ['Order Content', 'order_content'],['Courrier', 'courrier'], ['Date Delivered', 'date_delivered']
  end

  def vendor_table_options
    vendor_table_options =  [["id","id"], ["name","name"], ["created_at","created_at"], ["updated_at"]]
  end

  def get_table_option
    if @user.table_options.where(resource_table_type: resource_table).first.present?
      # get_table_option = @user.table_options.where(resource_table_type: resource_table).first
      ActiveSupport::JSON.decode(@user.table_options.where(resource_table_type: resource_table).first.option_list)
    else
      get_table_options = order_table_options if @resource_table == 'Orders'
      get_table_options = purchaser_table_options if @resource_table == 'Purchasers'
      get_table_options = vendor_table_options if @resource_table == 'Vendors'
    end
  end

  # def sanatize_user_table_options
  #   ActiveSupport::JSON.decode(get_table_option.option_list)
  # end

  # def selected_table_options
  #   selected_table_options = Array.new
  #   active_options_arr = get_table_option.to_a
  #
  #   order_table_options.map {|o| selected_table_options << o if active_options_arr.include? o[1] }
  #
  #   return selected_table_options
  #
  # end

  def selected_table_options

    if @user.table_options.where(resource_table_type: resource_table).first.present?
        selected_table_options = Array.new
        active_options_arr = get_table_option.to_a

        order_table_options.map {|o| selected_table_options << o if active_options_arr.include? o[1] }

        return selected_table_options
    else
        return order_table_options
    end

  end


end
