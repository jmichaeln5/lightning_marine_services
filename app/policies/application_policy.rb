# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  # def authorize(record, query = nil, policy_class: nil)
  #   query ||= "#{action_name}?"
  #
  #   # @_pundit_policy_authorized = true
  #
  #   # Pundit.authorize(pundit_user, record, query, policy_class: policy_class, cache: policies)
  # end

  # class Scope
  #   def initialize(user, scope)
  #     @user = user
  #     @scope = scope
  #   end
  #
  #   def resolve
  #     raise NotImplementedError, "You must define #resolve in #{self.class}"
  #   end
  #
  #   private
  #
  #   attr_reader :user, :scope
  # end
end
