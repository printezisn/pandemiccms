# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = {
    url: "redis://#{Rails.application.config.redis[:host]}:#{Rails.application.config.redis[:port]}",
    password: Rails.application.config.redis[:password]
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: "redis://#{Rails.application.config.redis[:host]}:#{Rails.application.config.redis[:port]}",
    password: Rails.application.config.redis[:password]
  }
end
