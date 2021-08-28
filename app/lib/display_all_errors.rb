module DisplayAllErrors

  def display_all_errors(resource)
    # byebug
    # ObjectSpace.each_object(Class) { |class| p class } # prints all classes in app

    # get_resource(controller_name)
    byebug

    resource.errors.each do |error|
      # @order.included_modules
        # byebug


      message = error.full_message
      # flash[:alert] = message
      # full_messages
      flash[:alert] = message
      end


  end







  def say_hello
    puts "Hello"
  end

  # byebug

end
