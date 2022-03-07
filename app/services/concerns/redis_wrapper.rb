# frozen_string_literal: true

# Concern with wrapper methods around redis
module RedisWrapper
  def redis
    @redis ||= Redis.new(
      host: Rails.application.config.redis[:host],
      port: Rails.application.config.redis[:port],
      password: Rails.application.config.redis[:password]
    )
  end
end
