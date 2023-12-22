module OrderContent::CastablePackageTypeFields
  extend ActiveSupport::Concern

  def has_package_type_amount?(attr_name)
    attr_val = send(attr_name)

    return false if attr_val.nil?
    return false if attr_val.blank?
    return false if attr_val == '0'

    return true
  end

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
end
