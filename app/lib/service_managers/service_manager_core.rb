module ServiceManagers
  module ServiceManagerCore
    extend ServiceManagers # Heroku/Zeitwerk error: expected file /app/app/lib/service_managers/service_manager_core.rb to define constant ServiceManagers::ServiceManagerCore, but didn't (Zeitwerk::NameError) 

    def init_service_manager( options={} ) # Set ivars to be used in when called in classes below
      options.each { |k,v| instance_variable_set("@#{k}", v) }
    end

  end
end
