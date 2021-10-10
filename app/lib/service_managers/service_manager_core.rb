module ServiceManagerCore

  def init_service_manager( options={} ) # Set ivars to be used in when called in classes below
    options.each { |k,v| instance_variable_set("@#{k}", v) }
  end

end
