# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = {
    url: "redis://#{Rails.application.credentials.redis[:host]}:#{Rails.application.credentials.redis[:port]}",
    password: Rails.application.credentials.redis[:password]
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: "redis://#{Rails.application.credentials.redis[:host]}:#{Rails.application.credentials.redis[:port]}",
    password: Rails.application.credentials.redis[:password]
  }
end
