require_relative 'boot'

require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LightningMarineServices
  class Application < Rails::Application
    config.load_defaults 6.0

    if Rails.env.test?
      config.autoloader = :classic
    end

    # config.assets.initialize_on_precompile = false # Note from initial push to prod, Heroku is trying to connect to DB as part of 'rake assets:precompile' but cannot because DB has not been created yet
    config.assets.initialize_on_precompile = true

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
