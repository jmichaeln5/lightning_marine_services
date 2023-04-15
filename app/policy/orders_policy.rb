# https://blog.eq8.eu/article/policy-object.html
# https://www.honeybadger.io/blog/complete-guide-to-managing-user-permissions-in-rails-apps/#:~:text=Policy%20Object%20is%20a%20design,policy%20objects%20with%20different%20rules

class OrdersPolicy
  attr_reader :user, :order

  def initialize(user, order)
    @user = user
    @order = order
  end

  def able_to_moderate?
    return true if user.has_role? "admin"
    return true if user.has_role? "staff"
    return false
  end

end


# module OrdersPolicy
#   include OrdersCreationPolicy
# end
