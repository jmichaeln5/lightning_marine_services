module OrderContent::Packageables
  extend ActiveSupport::Concern

  included do
    include CastablePackageTypeFields

    has_many :packaging_materials, dependent: :destroy do
      def types
        select(:type).distinct.collect { |packaging_material| packaging_material.type }
      end

      def types_names
        select(:type).distinct.collect { |packaging_material| packaging_material.type_name }
      end

      def type_options
        select(:type).distinct.collect { |packaging_material|
          [packaging_material.type_name, packaging_material.type]
        }
      end

      def by_type(type)
        return Array.new unless (type.in? types)
        where(type: type)
      end

      def by_type_name(type)
        filter_type = type.classify
        filtered_ids = Array.new
        return filtered_ids unless (filter_type.in? types_names)

        collect { |packaging_material|
          filtered_ids.push(packaging_material.id) if packaging_material.type_name == filter_type
        }
        where(id: filtered_ids.compact)
      end
    end

    has_many :packaging_materials_boxes, class_name: 'PackagingMaterial::Box' do
      def without_descriptions
        where(description: [nil, ''])
      end

      def with_descriptions
        where.not(description: [nil, ''])
      end
    end

    # has_many :packaging_materials, dependent: :destroy
    # has_many :packaging_materials_boxes, class_name: 'PackagingMaterial::Box'
    has_many :packaging_materials_crates, class_name: 'PackagingMaterial::Crate'
    has_many :packaging_materials_pallets, class_name: 'PackagingMaterial::Pallet'
    has_many :packaging_materials_others, class_name: 'PackagingMaterial::Other'

    accepts_nested_attributes_for :packaging_materials, allow_destroy: true
  end
end
