class DataTableDecorator
  # include ActionView::Helpers
  # include ActionView::Helpers::TagHelper

  attr_reader :object

  def initialize(object)
    @object = object
  end

  def self.table_attrs
    %i(id order_sequence status dept ship_name vendor_name po_number date_recieved order_content courrier date_delivered)
  end

  def self.ths
    %i(id order_sequence status dept ship_name vendor_name po_number date_recieved order_content courrier date_delivered)
  end

  def self.sortable_table_headers_attrs
    self.ths - %i(order_sequence dept po_number order_content )
  end


  def self.get_sortable_link(attr)
    table_attrs_hash = Hash.new

    return nil unless attr.in?(sortable_table_headers_attrs)

    if attr == :id
      # debugger
    end

    table_attrs.each do |_attr|
      # debugger

      _attr
    end

    # table_attrs_hash[:attr]
    # table_attrs_hash[:attr_title]
    # table_attrs_hash[:attr_sort_link]

    # %i(id order_sequence status dept purchaser vendor po_number date_recieved order_content courrier date_delivered)
  end



  def self.format_css_class(attr, class_list)
    _class_list = class_list.dup
    # 13 <= attr.to_s.length ? (_class_list << " text-center") : (_class_list << " whitespace-nowrap text-left")

    if (13 <= attr.to_s.length)
      (_class_list << " text-center")
    else
      (_class_list << " whitespace-nowrap")
    end
    return _class_list
  end
end
