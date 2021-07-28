# frozen_string_literal: true

# Service class used to fetch objects from the cache or store them if they are not cached
class CacheFetcher < ApplicationService
  def initialize(client, cache_version, key, &block)
    super()
    @client = client
    @cache_version = cache_version
    @key = key
    @block = block
  end

  def call
    return block.call unless client.cache_enabled?

    Rails.cache.fetch(
      [key, client.id, cache_version],
      expires_in: client.cache_duration&.minutes,
      race_condition_ttl: 10.seconds,
      &block
    )
  end

  private

  attr_reader :client, :cache_version, :key, :block
end
