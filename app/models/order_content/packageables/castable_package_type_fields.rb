module OrderContent::Packageables::CastablePackageTypeFields
  extend ActiveSupport::Concern

  def has_castable_package_amount?(attr_name)
    attr_val = send(attr_name)

    return true if attr_val.nil?
    return true if attr_val.blank?
    return false if attr_val.count("a-zA-Z") > 0
    return true
  end

  def cast_package_amount_to_i!(attr_name)
    send(attr_name).to_i
  end

  def attr_castable?(attr_name)
    attr_val = send(attr_name)

    return true if attr_val.nil?
    return true if attr_val.blank?
    return false if attr_val.count("a-zA-Z") > 0
    return true
  end

  def castable?
    return false if packaging_materials.size > 0
    return false if ((packaging_material_str_attrs.collect {|attr_str| attr_castable?(attr_str) }).include? false)
    return true
  end

  included do
    def packaging_material_str_attrs
      %w(box crate pallet other)
    end

    def set_string_attrs_from_packaging_materials
      if castable?
        set_castable_str_attrs_from_records if packaging_materials.any?
        build_records_from_castable_attrs unless packaging_materials_amounts_match_str_attrs?
      end
    end

    def packaging_materials_amounts_match_str_attrs?
      matching_vals = true

      PackagingMaterialDecorator.types_with_humanized.each do |type|
        return false unless matching_vals

        if type[0].downcase.in? packaging_material_str_attrs
          attr_amount_val = send(type[0].downcase)

          packaging_materials_type_amount_arr = Array.new
          packaging_materials.collect {|material| packaging_materials_type_amount_arr.push(material) if material.type == type[1] }

          matching_vals =  packaging_materials_type_amount_arr.compact.size == attr_amount_val.to_i
        end
      end
      return matching_vals
    end

    # def build_records_from_castable_attrs
    #   packaging_material_str_attrs.each do |packaging_material_attr|
    #     packaging_material_klass_str = "PackagingMaterial::#{packaging_material_attr.classify}"
    #     packaging_material_records_size = get_packaging_materials_size_by_type packaging_material_klass_str
    #     attr_val = send packaging_material_attr
    #
    #     if attr_val != packaging_material_records_size.to_s
    #       build_packaging_material_from_order_content(
    #         attr_val: attr_val,
    #         record_amount: packaging_material_records_size,
    #         klass_name: packaging_material_klass_str,
    #       ) unless (attr_val.to_i < packaging_material_records_size)
    #     end
    #   end
    # end

    def build_records_from_castable_attrs
      packaging_material_str_attrs.each do |packaging_material_attr|
        packaging_material_klass_str = "PackagingMaterial::#{packaging_material_attr.classify}"
        packaging_material_records_size = get_packaging_materials_size_by_type packaging_material_klass_str
        attr_val = send packaging_material_attr

        if attr_castable?(packaging_material_attr)
          if attr_val != packaging_material_records_size.to_s
            build_packaging_material_from_order_content(
              attr_val: attr_val,
              record_amount: packaging_material_records_size,
              klass_name: packaging_material_klass_str,
            ) unless (attr_val.to_i < packaging_material_records_size)
          end
        end
      end
    end

    private
      def build_packaging_material_from_order_content(attr_val:, record_amount:, klass_name:)
        build_amount = attr_val.to_i
        klass = klass_name.safe_constantize

        build_amount.times do
          klass.new(order_content: self)
        end
      end

      def set_castable_str_attrs_from_records
        self.box = get_packaging_materials_boxes_size.to_s if box != get_packaging_materials_boxes_size.to_s
        self.crate = get_packaging_materials_crates_size.to_s if crate != get_packaging_materials_crates_size.to_s
        self.pallet = get_packaging_materials_pallets_size.to_s if pallet != get_packaging_materials_pallets_size.to_s
        self.other = get_packaging_materials_others_size.to_s if other != get_packaging_materials_others_size.to_s
      end
  end
end
