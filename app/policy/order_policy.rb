# app/policy/client_policy.rb
class OrderPolicy
  attr_reader :current_user, :resource

  def initialize(current_user:, resource:)
    @current_user = current_user
    @resource = resource
  end

  def able_to_moderate?
    return false unless Current.user
    current_user.has_role? "admin" || current_user.moderator_for?(resource)
  end
end
