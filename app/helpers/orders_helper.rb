module OrdersHelper

  def sortable_orders_ths
    display_on_th = %i[
      id
      purchaser_id
      vendor_id
      courrier
      date_recieved
    ]
  end

  def remaining_th_attr_names_arr
    display_on_th = %i[
      po_number
      order_content
    ]
  end

end
