module Order::Sortable
  extend ActiveSupport::Concern

  included do
    def self.sortable_attrs
      %i(
        id
        order_sequence
        status
        courrier
        ship_name
        purchaser_name
        vendor_name
        date_recieved
        date_delivered
      )
    end
  end
end
