# frozen_string_literal: true

# Base application helper
module ApplicationHelper
  def client_view_cache(key, &)
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

  def client_object_cache(key, &)
    return yield unless current_client.cache_enabled?

    Rails.cache.fetch(
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

  def preload_fonts(*font_names)
    ViteRuby.instance.manifest.send(:manifest).values.pluck('file').map do |font|
      next '' if !font.ends_with?('.woff2') || font_names.none? { |n| font.include?(n) }

      tag.link rel: 'preload', href: font, as: 'font', type: 'font/woff2', crossorigin: 'anonymous'
    end.join("\n")
  end
end
