autoload :ResourceCore, "resources/resource_core.rb"

module Resource
  extend ResourceCore # Allowing Use of init_service_manager method to initialize ServiceManager Ivars

  def self.new_resource_struct( options = {} )
    @resource = Struct.new(*options.keys).new(*options.values)
  end

end


# Resource::ServiceManagerPaginateResource::WithSortDirection.new.is_satisfied_by?(@resource) # => true
