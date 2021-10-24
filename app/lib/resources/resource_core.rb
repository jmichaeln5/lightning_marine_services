module ResourceCore
  def init_resource( options={} ) # Set ivars to be used in when called in classes below
    options.each { |k,v| instance_variable_set("@#{k}", v) }
  end

  def reload_ivars(options = nil)
    # byebug
    self.instance_variables.each do |ivar|
      next if ivar == '@attributes'
      self.instance_variable_set(ivar, nil)
    end

  end

end
