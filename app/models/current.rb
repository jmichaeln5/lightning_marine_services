class Current < ActiveSupport::CurrentAttributes
  # attribute :account, :user
  attribute :user, :user_time_zone
  attribute :request_id, :user_agent, :ip_address, :request_variant

  resets { Time.zone = nil }
  # attribute :time_zone, default: -> { Time.zone.now }
  # attribute :time_zone

  def user=(user)
    super
    # self.account = user.account
    # Time.zone = user.time_zone
    self.user_time_zone = Time.zone.now
  end
end
