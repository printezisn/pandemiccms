# frozen_string_literal: true

# Decorator for category model
class CategoryDecorator < ApplicationDecorator
  delegate_all

  def path(language = nil)
    locale = language&.locale || I18n.locale

    Rails.application.routes.url_helpers.category_path(
      id: object.id,
      slug: object.translate(locale, use_defaults: true).displayed_slug(language&.transliterations),
      locale: locale
    )
  end
end
