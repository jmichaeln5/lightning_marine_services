module TableOptionsHelper

  #### # Remove this method (select_options_tag)
  # def select_options_tag(name='',select_options={},options={})
  #   #set selected from value
  #   selected = ''
  #   unless options[:value].blank?
  #     selected = options[:value]
  #     options.delete(:value)
  #   end
  #   select_tag(name,options_for_select(select_options,selected),options)
  # end

  def self.order_options_for_select_arr
    [ ['Order ID', 'id'], ['Dept', 'dept'], ['Ship', 'ship_name'], ['Vendor', 'vendor_name'], ['PO Number', 'po_number'], ['Date Received', 'date_recieved'], ['Order Content', 'order_content'],['Courrier', 'courrier'], ['Date Delivered', 'date_delivered'] ]
  end

  def self.purchaser_index_options_for_select_arr
    [ ["Ship ID","id"], ['Ship', 'name'], ['Ship Orders', 'order_amount'] ]
  end

  def self.purchaser_show_options_for_select_arr
    [ ["Order ID","id"], ['Dept', 'dept'], ['Vendor', 'vendor_name'], ['PO Number', 'po_number'], ['Date Received', 'date_recieved'], ['Order Content', 'order_content'],['Courrier', 'courrier'], ['Date Delivered', 'date_delivered'] ]
  end

  def self.vendor_index_options_for_select_arr
    [ ["Vendor ID","id"], ['Vendor', 'name'], ['Vendor Orders', 'order_amount'] ]
  end

  def self.vendor_show_options_for_select_arr
    [ ["Order ID","id"], ['Dept', 'dept'], ['Ship', 'ship_name'], ['PO Number', 'po_number'], ['Date Received', 'date_recieved'], ['Order Content', 'order_content'],['Courrier', 'courrier'], ['Date Delivered', 'date_delivered'] ]
  end

  def self.default_table_options_for_form(controller_name_and_action)

    return purchaser_index_options_for_select_arr if controller_name_and_action == 'purchasers#index'
    return purchaser_show_options_for_select_arr if controller_name_and_action == 'purchasers#show'

    return vendor_index_options_for_select_arr if controller_name_and_action == 'vendors#index'
    return vendor_show_options_for_select_arr if controller_name_and_action == 'vendors#show'

    return order_options_for_select_arr if controller_name_and_action == 'orders#index' || 'orders#show'
  end

  # def self.default_table_options(controller_name, action_name)
  #   return order_options_for_select_arr if resource_table == 'orders'
  #   # Other actions called in BusinessLogicTableOption corresponding method
  # end

  def self.options_for_resources_per_page
    [ [10], [25], [50], [100], [150] ]
  end
end
