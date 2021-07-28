# frozen_string_literal: true

# Base application helper
module ApplicationHelper
  def client_cache(key, &block)
    cache_if(
      current_client.cache_enabled?,
      [current_client.id, current_cache_version, key],
      expires_in: current_client.cache_duration.minutes,
      &block
    )
  end
end
