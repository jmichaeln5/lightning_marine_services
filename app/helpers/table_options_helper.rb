module TableOptionsHelper
  def self.order_options_for_select_arr
    # [ ['Order ID from helper', 'id'], ['Dept', 'dept'], ['Ship', 'ship_name'], ['Vendor', 'vendor_name'], ['PO Number', 'po_number'], ['Date Received', 'date_recieved'], ['Order Content', 'order_content'],['Courrier', 'courrier'], ['Date Delivered', 'date_delivered'] ]
    [ ['Order ID', 'id'], ['Dept', 'dept'], ['Ship', 'ship_name'], ['Vendor', 'vendor_name'], ['PO Number', 'po_number'], ['Date Received', 'date_recieved'], ['Order Content', 'order_content'],['Courrier', 'courrier'], ['Date Delivered', 'date_delivered'] ]
  end

  def self.purchaser_options_for_select_arr
    [ ["Order ID","id"], ['Dept', 'dept'], ['Vendor', 'vendor_name'], ['PO Number', 'po_number'], ['Date Received', 'date_recieved'], ['Order Content', 'order_content'],['Courrier', 'courrier'], ['Date Delivered', 'date_delivered'] ]
  end

  def self.vendor_options_for_select_arr
    [ ["Order ID","id"], ['Dept', 'dept'], ['Ship', 'ship_name'], ['PO Number', 'po_number'], ['Date Received', 'date_recieved'], ['Order Content', 'order_content'],['Courrier', 'courrier'], ['Date Delivered', 'date_delivered'] ]
  end

  def self.default_table_options(resouce_controller_name)
    resource_table = resouce_controller_name.capitalize.singularize

    return order_options_for_select_arr if resource_table == 'Order'
    return purchaser_options_for_select_arr if resource_table == 'Purchaser'
    return vendor_options_for_select_arr if resource_table == 'Vendor'
  end


end
