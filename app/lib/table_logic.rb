module TableLogic


  def self.ignore_attrs_on_table
    ignore_attrs_on_table = ['created_at', 'updated_at']
  end

  def self.th_attr_names_arr
    display_on_th = []

    Order.attribute_names.each do | attr |
      display_on_th << attr.to_s.strip.tr("'", '') unless (ignore_attrs_on_table.include?(attr))
    end

    display_on_th << "order_content"
    display_on_th << "purchaser"

    attr_names_arr = display_on_th
  end

  def self.say_hello
    "Hello"
  end

  # byebug

end
