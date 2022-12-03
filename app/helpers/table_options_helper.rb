module TableOptionsHelper

  def self.sortable_ths
    sortable_ths = ["id", "order_sequence","dept", "ship_name", "vendor_name", "date_recieved", "courrier", "date_delivered"]
  end

  def self.order_options_for_select_arr
    [ ['Order ID', 'id'], ['Seq', 'order_sequence'], ['Dept', 'dept'], ['Ship', 'ship_name'], ['Vendor', 'vendor_name'], ['PO Number', 'po_number'], ['Tracking Number','tracking_number'], ['Date Received', 'date_recieved'], ['Order Content', 'order_content'],['Courrier', 'courrier'], ['Date Delivered', 'date_delivered'] ].map {|option| option[1]}
  end

  def self.order_index_options_for_select_arr
    [ ['Order ID', 'id'], ['Seq', 'order_sequence'],['Dept', 'dept'], ['Ship', 'ship_name'], ['Vendor', 'vendor_name'], ['PO Number', 'po_number'], ['Tracking Number','tracking_number'], ['Date Received', 'date_recieved'], ['Order Content', 'order_content'],['Courrier', 'courrier'], ['Date Delivered', 'date_delivered'] ].map {|option| option[1]}
  end
  # def self.order_all_orders_options_for_select_arr
  #   [ ['Order ID', 'id'], ['Dept', 'dept'], ['Ship', 'ship_name'], ['Vendor', 'vendor_name'], ['PO Number', 'po_number'], ['Date Received', 'date_recieved'], ['Order Content', 'order_content'],['Courrier', 'courrier'], ['Date Delivered', 'date_delivered'] ].map {|option| option[1]}
  # end

  def self.purchaser_index_options_for_select_arr
    [ ["Ship ID","id"], ['Ship', 'name'], ['Ship Orders', 'order_amount'] ].map {|option| option[1]}
  end

  def self.purchaser_show_options_for_select_arr
    [ ["Order ID","id"], ["Seq","order_sequence"],['Dept', 'dept'], ['Vendor', 'vendor_name'], ['PO Number', 'po_number'], ['Tracking Number','tracking_number'], ['Date Received', 'date_recieved'], ['Order Content', 'order_content'],['Courrier', 'courrier'], ['Date Delivered', 'date_delivered'] ].map {|option| option[1]}
  end

  def self.vendor_index_options_for_select_arr
    [ ["Vendor ID","id"], ['Vendor', 'name'], ['Vendor Orders', 'order_amount'] ].map {|option| option[1]}
  end

  def self.vendor_show_options_for_select_arr
    [ ["Order ID","id"], ['Dept', 'dept'], ['Ship', 'ship_name'], ['PO Number', 'po_number'], ['Tracking Number','tracking_number'], ['Date Received', 'date_recieved'], ['Order Content', 'order_content'],['Courrier', 'courrier'], ['Date Delivered', 'date_delivered'] ].map {|option| option[1]}
  end

  def self.default_table_options_for_form(controller_name_and_action)
    return purchaser_index_options_for_select_arr if controller_name_and_action == 'purchasers#index'
    return purchaser_show_options_for_select_arr if controller_name_and_action == 'purchasers#show'

    return vendor_index_options_for_select_arr if controller_name_and_action == 'vendors#index'
    return vendor_show_options_for_select_arr if controller_name_and_action == 'vendors#show'

    return order_options_for_select_arr if controller_name_and_action == 'orders#index' || 'orders#show' || 'orders#all_orders'
    # return order_all_orders_options_for_select_arr if controller_name_and_action == 'orders#all_orders'
  end

  def self.options_for_resources_per_page
    [ [10], [25], [50], [100], [150] ]
  end

  def self.set_default_options(table_option, default_table_option_list)
    table_option.option_list = default_table_options_for_form(default_table_option_list)
  end

end
