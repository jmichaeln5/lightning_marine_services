module Order::Searchable
  extend ActiveSupport::Concern

  included do
    searchkick

    include Matches

    delegate :searchable_attrs, to: :class

    scope :search_import, -> {
      includes(
        :order_content,
        :purchaser,
        :vendor
      )
    }

    def self.searchable_attrs
      %w(po_number ship_name vendor_name)
    end

    def search_data
      {
        po_number: po_number,
        ship_name: ship_name,
        vendor_name: vendor_name,
      }
    end
  end
end
