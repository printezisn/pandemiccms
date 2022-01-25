# frozen_string_literal: true

# Base application helper
module ApplicationHelper
  def css(name)
    content_tag(:link, nil, { href: AssetPathFetcher.call(name, '.css'), rel: 'stylesheet', media: 'all' })
  end

  def js(name)
    content_tag(:script, nil, { src: AssetPathFetcher.call(name, '.js'), defer: 'defer' })
  end

  def client_cache(key, &)
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
      &
    )
  end
end
