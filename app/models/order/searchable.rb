module Order::Searchable
  extend ActiveSupport::Concern

  included do
    include Searchable

    scope :search_import, -> { includes(:purchaser, :vendor) }
  end

  def search_data
    {
      dept: dept,
      po_number: po_number,
      courrier: courrier,
      ship_name: purchaser.name,
      vendor_name: vendor.name
    }
  end
end
