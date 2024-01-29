module Order::Exportable
  extend ActiveSupport::Concern
  class_methods do
    def to_csv(options: nil)
      export_records = options.fetch(:orders, Order.active).order("order_sequence ASC")
      columns = options.fetch(:columns, DataTableDecorator.table_attrs)

      non_order_tds = %w(box crate pallet other)
      non_order_tds.push "order_content"

      CSV.generate do |csv|
        csv << columns
        export_records.each do |order|
          row = Array.new
          columns.each do |column|
            _column = column.parameterize
            if column == "order_content"
              packaging_material_attrs = %w(box crate pallet other)
              packaging_material_attrs.each do |packaging_material|
                order_content_decorator = OrderContentDecorator.new(order.order_content)
                case packaging_material
                when "box"
                  packaging_material_val = order_content_decorator.packaging_materials_boxes_td
                when "crate"
                  packaging_material_val = order_content_decorator.packaging_materials_crates_td
                when "pallet"
                  packaging_material_val = order_content_decorator.packaging_materials_pallets_td
                when "other"
                  packaging_material_val = order_content_decorator.packaging_materials_others_td
                end
                packaging_material_str = "#{packaging_material.pluralize}: #{packaging_material_val}"
                row.push(packaging_material_str)
              end
            end
            row.push(order.send(_column)) if order.respond_to?(_column)
          end
          csv << row
        end
      end
    end
  end
end
