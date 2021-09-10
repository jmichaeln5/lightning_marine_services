module SortTableLogic

  def self.get_resource(controller_name)
      klass = Object.const_get "#{controller_name.singularize.capitalize}"
  end

  def self.ignore_attrs_on_table
    ignore_attrs_on_table = ['created_at', 'updated_at']
  end

# ## ****** # GETS ALL ATTRS FOR TABLE HEADERS
  # def self.th_attr_names_arr
  #   display_on_th = []
  #
  #   Order.attribute_names.each do | attr |
  #     display_on_th << attr.to_s.strip.tr("'", '') unless (ignore_attrs_on_table.include?(attr))
  #   end
  #
  #   display_on_th << "order_content"
  #   display_on_th << "purchaser"
  #
  #   attr_names_arr = display_on_th
  # end

  def self.th_attr_names_arr
    display_on_th = %i[
      id
      purchaser_id
      vendor_id
      po_number
    ]

    attr_names_arr = display_on_th
  end


  def self.sort_resource_by_id(sort_direction)
    @orders = Order.order( "ID" + " " + sort_direction )
  end

  def self.sort_resource_by_purchaser_name(sort_direction)
    @orders = Order.includes(:purchaser).references(:purchaser).reorder("name" + " " + sort_direction)
  end

  def self.sort_resource_by_vendor_name(sort_direction)
    @orders = Order.includes(:vendor).references(:vendor).reorder("name" + " " + sort_direction)
  end

  def self.sort_resource_by_po_number(sort_direction)
    @orders = Order.order( "po_number" + " " + sort_direction )
  end

end
