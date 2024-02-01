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

    accepts_nested_attributes_for :packaging_materials, allow_destroy: true

    has_many :packaging_materials_boxes, class_name: 'PackagingMaterial::Box' do
      include Describable
    end
    alias_method :boxes, :packaging_materials_boxes


    has_many :packaging_materials_crates, class_name: 'PackagingMaterial::Crate' do
      include Describable
    end
    alias_method :crates, :packaging_materials_crates


    has_many :packaging_materials_pallets, class_name: 'PackagingMaterial::Pallet' do
      include Describable
    end
    alias_method :pallets, :packaging_materials_pallets


    has_many :packaging_materials_others, class_name: 'PackagingMaterial::Other' do
      include Describable
    end
    alias_method :others, :packaging_materials_others

    # before_validation do
    #   order_content.set_string_attrs_from_packaging_materials if cast_packaging_materials # only for existing, so no need to call on create # 👈🏾  packaging_materials created via Order#accepts_nested_attributes_for :order_content
    #   ## 👆🏾 would not be able to validate an association that does not yet exist
    # end

    def has_packaging_materials?
      order_content_packaging_materials_size, marked_for_destruction_amount = packaging_materials.size, 0
      packaging_materials.collect { |packaging_material| (marked_for_destruction_amount += 1) if packaging_material.marked_for_destruction? }

      order_content_packaging_materials_size > marked_for_destruction_amount
    end

    def packaging_materials_attributes_pair
      matching_attr_values_hash = Hash.new
      matching_attr_values_hash[:order_content_attributes], matching_attr_values_hash[:packaging_materials_attributes] = Array.new, Array.new

      order_content_packaging_materials_attribute_names.map {|attr_name|
        _attrs = self.attributes
        matching_attr_values_hash[:order_content_attributes].push(_attrs) unless _attrs.in?(matching_attr_values_hash[:order_content_attributes])

        matching_packaging_materials = packaging_materials.where(type: "PackagingMaterial::#{attr_name.classify}")
        packaging_materials_attributes_hash = Hash.new

        if matching_packaging_materials.any?
          matching_packaging_materials.map {|_pm|
            matching_attr_values_hash[:packaging_materials_attributes].push _pm.attributes
          }
        else
          packaging_materials_attributes_hash["packaging_materials_#{attr_name.downcase.pluralize}".to_sym] = nil
        end
      }
      matching_attr_values_hash
    end
  end
end
