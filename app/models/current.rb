class Current < ActiveSupport::CurrentAttributes
  # attribute :account, :user
  attribute :user
  attribute :request_id, :user_agent, :ip_address, :request_variant

  # resets { Time.zone = nil }

  # def user=(user)
  #   super
  #   # self.user = current_user
  #   # self.account = user.account
  #   # Time.zone    = user.time_zone
  # end
end
