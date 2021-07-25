# frozen_string_literal: true

# Decorator for tag model
class TagDecorator < ApplicationDecorator
  delegate_all

  def path(language = nil)
    Rails.application.routes.url_helpers.tag_path(
      id: object.id,
      slug: object.displayed_slug(language&.transliterations),
      locale: language&.locale || I18n.default_locale
    )
  end
end
