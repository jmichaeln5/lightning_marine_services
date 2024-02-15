module PackageablesEligibility
  extend ActiveSupport::Concern

  PACKAGING_MATERIALS_IMPLEMENTATION_DATE = Date.parse('2024-02-10')

  included do
    delegate :packaging_materials_implementation_date, to: :class

    def self.packaging_materials_implementation_date
      PACKAGING_MATERIALS_IMPLEMENTATION_DATE
    end

    def recieved_before_packaging_materials_implementation_date?
      return false unless date_recieved?

      date_recieved < packaging_materials_implementation_date
    end

    def created_before_packaging_materials_implementation_date?
      return false if new_record?

      created_at < packaging_materials_implementation_date
    end

    def created_after_packaging_materials_implementation_date?
      !created_before_packaging_materials_implementation_date?
    end

    def self.all_created_before_packaging_materials_implementation_date
      where("created_at < ?", packaging_materials_implementation_date)
    end
  end
end
