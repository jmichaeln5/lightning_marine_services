module Order::Filterable
  extend ActiveSupport::Concern

  included do
    def self.filterable_attrs
      %w(id order_sequence status dept purchaser_id vendor_id date_recieved courrier date_delivered)
    end
  end

  module ClassMethods
    def filter(filtering_params)
      filters = Hash.new
      filtering_params.collect {|key, value| (filters[key] = value) if key.in?(filterable_attrs)}

      where(filters)
    end
  end
end
