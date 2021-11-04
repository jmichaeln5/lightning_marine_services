# NOT ACTIVE RECORD TABLE OPTION

# autoload :TableOptionKlass, "services/table_options/table_option_klass.rb"
module IndependentTableOption
  # extend TableOptionKlass

  def self.get_independent_table_option_module(resource)
    table_option_parent_class_module = "IndependentTableOption#{resource.parent_class.name.pluralize}"
    table_option_parent_action_module = "#{table_option_parent_class_module}#{resource.parent_action.camelize}"
    return "#{table_option_parent_class_module}::#{table_option_parent_action_module}"
  end

  def self.trigger_default_resource_table_option(resource)
    controller_name_and_action = "#{resource.parent_class.name.downcase.pluralize}" + "#" + "#{resource.parent_action.downcase}"

    resource_table_type = resource.parent_class.name.downcase.pluralize
    resource_table_action = resource.parent_action
    option_list = TableOptionsHelper.default_table_options_for_form(controller_name_and_action)
    user = resource.user

    case get_independent_table_option_module(resource)

    when "IndependentTableOptionPurchasers::IndependentTableOptionPurchasersShow"
      autoload :IndependentTableOptionPurchasers, "services/table_options/independent_table_options_purchasers/independent_table_option_purchasers.rb"
      extend IndependentTableOptionPurchasers::IndependentTableOptionPurchasersShow

      purchaser_show_table_option_klass = IndependentTableOptionPurchasersShow::IndependentTableOptionPurchasersShowKlass
      return purchaser_show_table_option_klass.new(
        resource_table_type,
        resource_table_action,
        option_list,
        user,
        controller_name_and_action
      )

    when "IndependentTableOptionVendors::IndependentTableOptionVendorsShow"
      autoload :IndependentTableOptionVendors, "services/table_options/independent_table_options_vendors/independent_table_option_vendors.rb"
      extend IndependentTableOptionVendors::IndependentTableOptionVendorsShow

      vendor_show_table_option_klass = IndependentTableOptionVendorsShow::IndependentTableOptionVendorsShowKlass
      return vendor_show_table_option_klass.new(
        resource_table_type,
        resource_table_action,
        option_list,
        user,
        controller_name_and_action
      )

    else
      autoload :TableOptionKlass, "services/table_options/table_option_klass.rb"
      extend TableOptionKlass

      return TableOptionKlass::TableOptionKlass.new(
        resource_table_type,
        resource_table_action,
        option_list,
        user,
        controller_name_and_action
      )
      
    end
  end


end
