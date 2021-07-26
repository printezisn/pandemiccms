# frozen_string_literal: true

# Service class used to fetch objects from the cache or store them if they are not cached
class CacheFetcher < ApplicationService
  def initialize(client, key, &block)
    super()
    @client = client
    @key = key
    @block = block
  end

  def call
    return block.call unless client.cache_enabled?

    Rails.cache.fetch(key, expires_in: client.cache_duration.minutes, &block)
  end

  private

  attr_reader :client, :key, :block
end
