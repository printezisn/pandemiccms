# frozen_string_literal: true

# Decorator for category model
class CategoryDecorator < ApplicationDecorator
  delegate_all

  def path(language = nil)
    Rails.application.routes.url_helpers.category_path(
      id: object.id,
      slug: object.displayed_slug(language&.transliterations),
      locale: language&.locale || I18n.default_locale
    )
  end
end
