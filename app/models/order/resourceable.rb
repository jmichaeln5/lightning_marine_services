module Order::Resourceable
  extend ActiveSupport::Concern

  included do
    belongs_to :purchaser
    belongs_to :vendor

    alias_attribute :ship, :purchaser

    delegate :purchaser_name, :ship_name, to: :purchaser
    delegate :vendor_name, to: :vendor
  end
end
