require_relative 'boot'

require 'csv'
########################################
########################################
### 4-17-23 # BEFORE
require 'rails/all'
# ########################################
# ### 4-17-23 # AFTER
# require "rails"
# # Pick the frameworks you want:
# require "active_model/railtie"
# require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
# require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
# require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# # require "rails/test_unit/railtie" # default tests
# ########################################
# ########################################

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LightningMarineServices
  class Application < Rails::Application
    # config.load_defaults 6.0 # requires  -v 6.0 load_defaults when -v 6.1 ????
    config.load_defaults 6.1 # should replace above with this

    #################################### Migrating to esbuild
    # config.assets.initialize_on_precompile = false # Note from initial push to prod, Heroku is trying to connect to DB as part of 'rake assets:precompile' but cannot because DB has not been created yet
    # config.assets.initialize_on_precompile = true ### Until uninstalled pack shizz
    ####################################

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.generators do |g|
      g.test_framework(
        :rspec,
        fixtures: false,
      )
    end
  end
end
