RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Warden::Test::Helpers
  Warden.test_mode!
end

### ex- login as user
#   user = create(:user)
#   login_as(user, scope: :user)
