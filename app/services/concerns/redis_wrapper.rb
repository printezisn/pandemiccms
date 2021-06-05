# frozen_string_literal: true

# Concern with wrapper methods around redis
module RedisWrapper
  def redis
    @redis ||= Redis.new(
      host: Rails.application.credentials.redis[:host],
      password: Rails.application.credentials.redis[:password]
    )
  end
end
