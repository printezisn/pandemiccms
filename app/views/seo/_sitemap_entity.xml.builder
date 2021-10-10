# frozen_string_literal: true

entity = entity.decorate

xml.url do
  xml.loc request.base_url + entity.path(current_language)
  xml.lastmod entity.updated_at.iso8601

  current_client.enabled_languages.each do |language|
    next if language.id == current_language.id

    xml.xhtml :link, 'rel' => 'alternate', 'hreflang' => language.locale, 'href' => request.base_url + entity.path(language)
  end
end
