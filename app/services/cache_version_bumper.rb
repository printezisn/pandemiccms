# frozen_string_literal: true

# Service class to bump the current cache version for a client
class CacheVersionBumper < ApplicationService
  include RedisWrapper

  attr_reader :client_id

  def initialize(client_id)
    super()
    @client_id = client_id
  end

  def call
    redis.incr(redis_key)
  end

  private

  def redis_key
    @redis_key ||= "cache_version_#{@client_id}_#{Rails.env}"
  end
end
