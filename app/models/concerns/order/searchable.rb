module Order::Searchable
  extend ActiveSupport::Concern

  included do
    searchkick
    scope :search_import, -> { includes(:purchaser, :vendor) }
  end

  def search_data
    {
      dept: dept,
      po_number: po_number,
      courrier: courrier,
      purchaser_name: purchaser.name,
      vendor_name: vendor.name
    }
  end
end

# Order.search_index.delete
# Order.reindex

# Order.search("341", fields: [:po_number], match: :word_start)
