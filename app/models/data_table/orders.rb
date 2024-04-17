class DataTable::Orders < DataTable
  delegate :table_headers, to: :class

  delegate_missing_to :klass

  def initialize(records = nil)
    @klass, @records = Order, records
    @records ||= Order.includes(:order_content, :packaging_materials, :purchaser, :vendor)
    @sortable_table_headers = Order.sortable_attrs
  end

  # def self.table_headers
  #   @table_headers ||= %i(
  #     id
  #     order_sequence
  #     status
  #     dept
  #     ship_name
  #     vendor_name
  #     po_number
  #     date_recieved
  #     order_content
  #     courrier
  #     date_delivered
  #   )
  # end

  def self.table_headers
    @table_headers ||= %i(order_sequence dept vendor_name po_number date_recieved boxes crates pallets courrier)
  end

  def self.format_row(order:, table_headers: nil)
    table_headers ||= %i(order_sequence dept ship_name vendor_name po_number date_recieved order_content courrier)

    order_owner_headers = %i(vendor_name purchaser_name ship_name)
    order_content_table_headers = %i(boxes crates pallets)

    row_hash = Hash.new

    table_headers.each do |table_header_attr|
      if (table_header_attr.to_s.in?(order.attribute_names) || table_header_attr.in?(order_owner_headers))
        order_decorator = OrderDecorator.new(order)
        table_header_attr_val = order_decorator.return_attr_or_str(table_header_attr, '')
      else
        case order.has_packaging_materials?
        when true
          table_header_attr_val = OrderContentDecorator.new(order.order_content).format_packaging_material_td(type: "PackagingMaterial::#{table_header_attr.to_s.classify}")
        when false
          _order_content = order.try :order_content
          table_header_attr_val = _order_content.nil? ? nil : _order_content.send(table_header_attr.to_s.downcase.singularize)
        else
          table_header_attr_val = nil
        end
        table_header_attr_val ||= '0'
      end

      row_hash[table_header_attr.to_s] = table_header_attr_val
    end

    return row_hash
  end

end
