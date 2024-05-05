# frozen_string_literal: true

# Service class to bump the current cache version for a client
class CacheVersionBumper < ApplicationService
  attr_reader :client_id

  def initialize(client_id)
    super()
    @client_id = client_id
  end

  def call
    Rails.cache.increment(cache_key)
  end

  private

  def cache_key
    @cache_key ||= "cache_version_#{@client_id}_#{Rails.env}"
  end
end
