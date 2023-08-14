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

  def find_humanized_key_from_value(val)
    search_data_arr = search_data.to_a

    matching_key = nil
    search_data_arr.map {|d| (matching_key = d[0]) if (d[1] == val) }

    humanized_key = self.class.human_attribute_name(matching_key.to_s) if matching_key
    humanized_key ||= matching_key

    return humanized_key
  end
end

# Order.search_index.delete
# Order.reindex

# Order.search("341", fields: [:po_number], match: :word_start)
