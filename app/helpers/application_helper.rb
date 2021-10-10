# frozen_string_literal: true

# Base application helper
module ApplicationHelper
  def client_cache(key, &block)
    cache_if(
      current_client.cache_enabled?,
      [
        request.base_url,
        current_client.id,
        current_cache_version,
        current_locale,
        admin_user_signed_in?,
        key
      ],
      expires_in: current_client.cache_duration&.minutes,
      race_condition_ttl: 10.seconds,
      &block
    )
  end
end
