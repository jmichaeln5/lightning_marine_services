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
      include Describable
    end

    has_many :packaging_materials_crates, class_name: 'PackagingMaterial::Crate' do
      include Describable
    end

    has_many :packaging_materials_pallets, class_name: 'PackagingMaterial::Pallet' do
      include Describable
    end

    has_many :packaging_materials_others, class_name: 'PackagingMaterial::Other' do
      include Describable
    end

    accepts_nested_attributes_for :packaging_materials, allow_destroy: true
  end

  def get_packaging_materials_size_by_type(type); packaging_materials.where(type: type).size; end;

  def get_packaging_materials_boxes_size; packaging_materials.where(type: 'PackagingMaterial::Box').size; end;

  def get_packaging_materials_crates_size; packaging_materials.where(type: 'PackagingMaterial::Crate').size; end;

  def get_packaging_materials_pallets_size; packaging_materials.where(type: 'PackagingMaterial::Pallet').size; end;

  def get_packaging_materials_others_size; packaging_materials.where(type: 'PackagingMaterial::Other').size; end;
end
