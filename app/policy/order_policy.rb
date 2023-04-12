# https://blog.eq8.eu/article/policy-object.html
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
