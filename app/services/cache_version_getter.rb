# frozen_string_literal: true

# Service class to get the current cache version for a client
class CacheVersionGetter < ApplicationService
  attr_reader :client_id

  def initialize(client_id)
    super()
    @client_id = client_id
  end

  def call
    Rails.cache.read(cache_key, raw: true) || '0'
  end

  private

  def cache_key
    @cache_key ||= "cache_version_#{@client_id}_#{Rails.env}"
  end
end
