module PackageablesEligibility
  extend ActiveSupport::Concern

  PACKAGING_MATERIALS_IMPLEMENTATION_DATE = Date.parse('2024-01-27')

  included do
    delegate :packaging_materials_implementation_date, to: :class

    def self.packaging_materials_implementation_date
      PACKAGING_MATERIALS_IMPLEMENTATION_DATE
    end

    def created_before_packaging_materials_implementation_date?
      return false if new_record?

      created_at < packaging_materials_implementation_date
    end

    def eligible_for_packaging_materials_validation?
      !created_before_packaging_materials_implementation_date?
    end

    def self.all_created_before_packaging_materials_implementation_date
      where("created_at < ?", packaging_materials_implementation_date)
    end
  end
end
