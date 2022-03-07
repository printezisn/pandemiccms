# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pandemiccms
  # Base application config
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.exceptions_app = routes

    config.search = config_for(:elasticsearch)
    config.redis = config_for(:redis)

    smtp_config = config_for(:smtp)
    if smtp_config.present?
      config.action_mailer.delivery_method = :smtp
      config.action_mailer.smtp_settings = smtp_config
    end

    config.available_languages = [
      { locale: 'en-GB', name: 'English', flag: 'gb' },
      { locale: 'el-GR', name: 'Ελληνικά', flag: 'gr', transliterations: 'greek' }
    ]
  end
end
