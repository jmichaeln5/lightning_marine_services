module OrdersHelper

  def sortable_orders_ths
    %i[
      id
      purchaser_id
      vendor_id
      courrier
      date_recieved
    ]
  end

  def non_sortable_orders_ths
    %i[
      po_number
      order_content
    ]
  end

end
