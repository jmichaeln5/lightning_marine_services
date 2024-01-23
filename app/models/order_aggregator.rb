class OrderAggregator
  module Scopes
    def filter_attrs
      Order.filterable_attrs
    end

    def by_status(status, attr_name: 'status')
      return self if status.blank?

      where(status: status)
    end

    def by_dept(dept, attr_name: 'dept')
      return self if dept.blank?

      if dept.class == String
        where('lower(dept) = ?', dept.downcase)
      else
        where(dept: dept)
      end
    end

    def by_courrier(courrier, attr_name: 'courrier')
      return self if courrier.blank?

      if courrier.class == String
        where('lower(courrier) = ?', courrier.downcase)
      else
        where(courrier: courrier)
      end
    end

    def by_purchaser_name(purchaser_name, attr_name: 'purchaser_name')
      return self if purchaser_name.blank?

      includes(:purchaser).references(:purchaser)
        .where('lower(name) = ?', purchaser_name.downcase)
    end

    def by_vendor_name(vendor_name, attr_name: 'vendor_name')
      return self if vendor_name.blank?

      includes(:vendor).references(:vendor)
        .where('lower(name) = ?', vendor_name.downcase)
    end
  end

  def self.filter(scope = Order, filters)
    scope
      .extending(Scopes)
      .by_dept(filters[:dept])
      .by_courrier(filters[:courrier])
      .by_status(filters[:status])
  end
end
