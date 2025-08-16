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

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.exceptions_app = routes

    config.mission_control.jobs.base_controller_class = 'SuperAdmin::BaseController'
    config.mission_control.jobs.http_basic_auth_enabled = false

    config.search = config_for(:search)
    config.super_admin = config_for(:super_admin)

    cache_config = config_for(:cache)
    config.cache_store = case cache_config[:type]
                         when 'redis'
                           [:redis_cache_store, { url: "redis://#{cache_config[:password]}@#{cache_config[:host]}:#{cache_config[:port]}" }]
                         when 'memory'
                           :memory_store
                         else
                           :null_store
                         end

    smtp_config = config_for(:smtp)
    if smtp_config.present?
      config.action_mailer.delivery_method = smtp_config[:delivery_method].to_sym
      config.action_mailer.smtp_settings = smtp_config.except(:delivery_method)
    end

    config.available_languages = [
      { locale: 'en-GB', name: 'English', flag: 'gb' },
      { locale: 'el-GR', name: 'Ελληνικά', flag: 'gr' }
    ]
  end
end
