module TableLogic


  # def self.ignore_attrs_on_table
  #   ignore_attrs_on_table = ['created_at', 'updated_at']
  # end
  #
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
  #
  # def self.say_hello
  #   "Hello"
  # end
  #
  # # byebug

  # ##### #############
  # ##### #############
  # ##### #############

  def sort_column(order_attr = nil)
    if params[:order_attr] == 'id'
      return 'id'
    elsif params[:order_attr] == 'purchaser_name'
      return 'purchaser_name'
    elsif params[:order_attr] == 'vendor_name'
      return 'vendor_name'
    end
  end


  def sort_direction
    if params[:order_attr] && params[:sort_direction] == 'DESC'
      'ASC'
    else
      "DESC"
    end
  end

# ##### #############

  @per_page = 5
  @archived_orders = Order.archived.order("created_at DESC")
  if sort_column == 'id'
    # byebug
    @orders = Order.unarchived.order( sort_column + " " + sort_direction )
    # byebug
  elsif sort_column == 'purchaser_name'
    @orders = Order.unarchived.includes(:purchaser).references(:purchaser).reorder("name" + " " + sort_direction)

  elsif sort_column == 'vendor_name'
    @orders = Order.unarchived.includes(:vendor).references(:vendor).reorder("name" + " " + sort_direction)
  else
    @orders = Order.unarchived.all.order("created_at DESC")
  end

  # ##### #############
  # ##### #############
  # ##### #############



end
