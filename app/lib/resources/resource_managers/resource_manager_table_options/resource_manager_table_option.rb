autoload :IndependentTableOption, "services/table_options/independent_table_option.rb"

module ResourceManagerTableOption
  extend IndependentTableOption

  def self.manage_table_option(resource)
    return IndependentTableOption.trigger_default_resource_table_option(resource)
  end

  def self.user_table_option(resource)
    user = resource.user
    resource_table_type = resource.controller_name
    resource_table_action = resource.controller_action

    return user.table_options.where(resource_table_type: resource_table_type, resource_table_action: resource_table_action ).first
  end

end
