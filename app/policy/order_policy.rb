# https://blog.eq8.eu/article/policy-object.html
# https://www.honeybadger.io/blog/complete-guide-to-managing-user-permissions-in-rails-apps/#:~:text=Policy%20Object%20is%20a%20design,policy%20objects%20with%20different%20rules
class OrderPolicy
  attr_reader :current_user, :resource

  def initialize(current_user:, resource:)
    @current_user = current_user
    @resource = resource
  end

  def able_to_moderate?
    # current_user.has_role? "admin" || current_user.moderator_for?(resource)
    # current_user.has_role? "admin" or current_user.has_role? "staff"
    return true if current_user.has_role? "admin"
    return true if current_user.has_role? "staff"
  end
end
