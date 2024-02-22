module Order::Exportable
  extend ActiveSupport::Concern

  included do
    def self.to_csv
      data_table = DataTable::Orders.new(all)
      orders = data_table.records

      table_headers = data_table.table_headers.dup

      order_content_index = table_headers.find_index(:order_content)
      remaining_table_headers = table_headers[order_content_index+1 .. -1]
      table_headers = table_headers - table_headers[order_content_index .. -1]
      order_content_table_headers = %i(boxes crates pallets others)
      order_content_table_headers.map {|th| table_headers.push(th) }
      remaining_table_headers.map {|th| table_headers.push(th) }

      table_headers = table_headers.collect {|th| th.to_s.humanize }.freeze

      CSV.generate do |csv|
        csv << table_headers
        orders.each do |order|
          order_decorator = OrderDecorator.new(order)

          id              = order_decorator.return_attr_or_str(:id, '')
          order_sequence  = order_decorator.return_attr_or_str(:order_sequence, '')
          status          = order_decorator.return_attr_or_str(:status, '')
          dept            = order_decorator.return_attr_or_str(:dept, '')
          purchaser_name  = order_decorator.return_attr_or_str(:purchaser_name, '')
          vendor_name     = order_decorator.return_attr_or_str(:vendor_name, '')
          po_number       = order_decorator.return_attr_or_str(:po_number, '')
          date_recieved   = order_decorator.return_attr_or_str(:date_recieved, '')

          if order.has_packaging_materials?
            attributes_hash = order.with_packaging_materials_attributes
            order_content_attributes = attributes_hash.dig(:order_content_attributes)
            packaging_materials_attributes = order_content_attributes.dig(:packaging_materials_attributes)

            unless packaging_materials_attributes.nil?
              order_content_decorator = OrderContentDecorator.new(order.order_content)
              box         = order_content_decorator.format_packaging_material_td(type: 'PackagingMaterial::Box')
              crate       = order_content_decorator.format_packaging_material_td(type: 'PackagingMaterial::Crate')
              pallet      = order_content_decorator.format_packaging_material_td(type: 'PackagingMaterial::Pallet')
              other       = order_content_decorator.format_packaging_material_td(type: 'PackagingMaterial::Other')
            end
          else
            box           = order.try(:order_content).box || '0'
            crate         = order.try(:order_content).crate || '0'
            pallet        = order.try(:order_content).pallet || '0'
            other         = order.try(:order_content).pallet || '0'
          end

          courrier        = order_decorator.return_attr_or_str(:courrier, '')
          date_delivered  = order_decorator.return_attr_or_str(:date_delivered, '')

          csv << [
            id, order_sequence, status,
            dept, purchaser_name, vendor_name,
            po_number, date_recieved,
            box, crate, pallet,
            other, courrier, date_delivered,
          ]
        end
      end
    end
  end
end
