module Order::Resourceable
  extend ActiveSupport::Concern

  included do
    alias_attribute :ship, :purchaser

    delegate :purchaser_name, :ship_name, to: :purchaser
    delegate :vendor_name, to: :vendor

    ### 👇🏾 👇🏾 👇🏾  NOTE - move to Order::Sortable (app/models/order/sortable/scopes.rb)
    # def self.order_by_vendor_name(sort_direction)
    #   includes(:vendor).references(:vendor).order("name" + " " + sort_direction)
    # end
    #
    # def self.order_by_purchaser_name(sort_direction)
    #   includes(:purchaser).references(:purchaser).order("name" + " " + sort_direction)
    # end

    def resourceables
      %i(ship vendor)
    end

    private
      # def set_default_sequence?
      #   order_sequence.nil? && purchaser_id?
      # end
      #
      # def set_default_sequence
      #   ship = Purchaser.find(self.purchaser_id)
      #   shipOrders = ship.orders.unarchived
      #   seq = 1
      #   shipOrders.each do |ord|
      #     iSeq = (ord.try(:order_sequence)|| 0)
      #     if iSeq >= seq
      #       seq = iSeq + 1
      #     end
      #   end
      #   self.order_sequence = seq
      # end
  end
end
