module Order::Sortable
  extend ActiveSupport::Concern

  included do
    def self.sortable_attrs
      # %w(id order_sequence status dept courrier ship_name purchaser_name vendor_name date_recieved date_delivered) # NOTE - removed dept due to both nil and "" values that modify sort order (asc- "", "value of str", nil) (desc- nil, "value of str", "")
      %w(id order_sequence status courrier ship_name purchaser_name vendor_name date_recieved date_delivered)
    end

    def self.sort(scope = nil, filters = nil)
      # Order
      scope
        .extending(SortableScopes)
        .by_dept(filters[:dept])
        .by_courrier(filters[:courrier])
        .by_status(filters[:status])
        .by_purchaser_name(filters[:purchaser_name])
        .by_vendor_name(filters[:vendor_name])
    end
  end

  module SortableScopes
    def by_dept(dept)
      return self if dept.blank?

      where('lower(dept) = ?', dept.downcase)
    end

    def by_courrier(courrier)
      return self if courrier.blank?

      where('lower(courrier) = ?', courrier.downcase)
    end

    def by_status(status)
      return self if status.blank?

      where(status: status)
    end

    def by_purchaser_name(purchaser_name)
      return self if purchaser_name.blank?

      includes(:purchaser).references(:purchaser)
        .where('lower(name) = ?', purchaser_name.downcase)
    end

    def by_vendor_name(vendor_name)
      return self if vendor_name.blank?

      includes(:vendor).references(:vendor)
        .where('lower(name) = ?', vendor_name.downcase)
    end
  end
end
