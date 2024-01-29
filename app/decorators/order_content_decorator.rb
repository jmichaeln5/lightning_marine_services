class OrderContentDecorator
  delegate :packaging_materials, to: :order_content

  attr_reader :order_content

  def initialize(order_content)
    @order_content = order_content
  end

  def packaging_materials_others_td
    # aggregated_packaging_material = OrderContent::PackagingMaterials::Aggregator.new(order_content, filter: 'others')
    packaging_material_summary_by_type('PackagingMaterial::Other')
  end

  def packaging_materials_boxes_td
    # aggregated_packaging_material = OrderContent::PackagingMaterials::Aggregator.new(order_content, filter: 'boxes')
    packaging_material_summary_by_type('PackagingMaterial::Box')
  end

  def packaging_materials_crates_td
    # aggregated_packaging_material = OrderContent::PackagingMaterials::Aggregator.new(order_content, filter: 'crates')
    packaging_material_summary_by_type('PackagingMaterial::Crate')
  end

  def packaging_materials_pallets_td
    # aggregated_packaging_material = OrderContent::PackagingMaterials::Aggregator.new(order_content, filter: 'crates')
    packaging_material_summary_by_type('PackagingMaterial::Pallet')
  end

  private  
    def packaging_material_summary_by_type(type)
      return '0' unless (type.in? PackagingMaterial::Packageable::TYPES)

      materials = packaging_materials.where(type: type)

      ids = materials.ids
      remaining_ids = materials.ids.dup

      without_desc = materials.where(description: [nil, ''])
      with_desc = materials.where.not(description: [nil, ''])

      ids_without_description = without_desc.ids
      ids_with_description = with_desc.ids

      td_display_arr = Array.new

      unless ((ids_without_description.count == 0) && (ids_with_description.count > 0))
        td_display_arr.push(ids_without_description.count.to_s)
      end

      return td_display_arr.join unless (ids_with_description.count > 0)

      remaining_ids = remaining_ids - ids_without_description

      packaging_materials_with_description_hash = Hash.new
      packaging_materials_with_description_hash[:packaging_materials] = Array.new

      remaining_ids.each do |packaging_material_id|
        if packaging_material_id.in? remaining_ids
          packaging_material = with_desc.find packaging_material_id

          matching_description_ids = materials.where(
            'lower(description) = ?', packaging_material.description.downcase
          ).ids

          packaging_materials_with_description_hash[:packaging_materials].push(
            { ids: matching_description_ids, description: packaging_material.description.upcase }
          )
          remaining_ids = remaining_ids - matching_description_ids
        end
      end

      td_display_arr.push(" + ") if ((with_desc.ids.count > 0) && ((without_desc.ids.count > 0)))

      packaging_materials_with_description_hash[:packaging_materials].each do |matching_packaging_materials_attrs|
        if td_display_arr.compact_blank.count > 0
          td_display_arr.push(" + ") unless (td_display_arr.last.strip == "+")
        end
        td_display_arr.push "#{matching_packaging_materials_attrs[:ids].count} #{matching_packaging_materials_attrs[:description]}"
      end

      return td_display_arr.join
    end
end
