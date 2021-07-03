# frozen_string_literal: true

# Concern with wrapper methods around redis
module RedisWrapper
  def redis
    @redis ||= Redis.new(
      host: Rails.application.credentials.redis[:host],
      port: Rails.application.credentials.redis[:port],
      password: Rails.application.credentials.redis[:password]
    )
  end
end
