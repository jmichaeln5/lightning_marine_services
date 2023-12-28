class PackagingMaterialDecorator
  delegate_missing_to :@packaging_material

  def initialize(packaging_material, view_context)
    @packaging_material, @view_context = packaging_material, view_context
  end

  def self.types
    PackagingMaterial::Packageable::TYPES
  end

  def self.humanized_types
    PackagingMaterial::Packageable::HUMANIZED_TYPES
  end

  def self.types_options
    type_options_arr = Array.new
    PackagingMaterial::Packageable::TYPES.map { |packaging_material_type|
      type_options_arr.push [(packaging_material_type.delete_prefix "PackagingMaterial::"), packaging_material_type]
    }
    type_options_arr
  end

  def self.index_path_options(order_content, packaging_material_type = nil)
    path_options_hash = Hash.new
    path_options_hash[:all] = { type: 'all', title: 'All', path: "order_content_packaging_materials_url" }

    PackagingMaterialDecorator.types_options.each do |type|
      path_options_hash[type[0].downcase.to_sym] = {
        type: type[1],
        title: type[0].capitalize.pluralize,
        path: "order_content_packaging_material_#{type[0].downcase.pluralize}_url"
      }
    end

    path_options_hash
  end

  def non_specified_type?
    (packaging_material.type.in? (PackagingMaterial::Packageable::TYPES - ["PackagingMaterial::Other"])) == false
  end
end
