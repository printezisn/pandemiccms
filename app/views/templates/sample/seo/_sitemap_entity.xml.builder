# frozen_string_literal: true

xml.url do
  xml.loc request.base_url + template_entity_path(entity)
  xml.lastmod entity.updated_at.iso8601

  current_client.enabled_languages.each do |language|
    next if language.id == current_language.id

    xml.xhtml :link, 'rel' => 'alternate', 'hreflang' => language.locale,
                     'href' => request.base_url + template_entity_path(entity, locale: language.locale)
  end
end
