# frozen_string_literal: true

# Decorator for post model
class PostDecorator < ApplicationDecorator
  delegate_all

  def path(language = nil)
    locale = language&.locale || I18n.locale

    Rails.application.routes.url_helpers.post_path(
      id: object.id,
      slug: object.translate(locale, use_defaults: true).displayed_slug,
      locale:
    )
  end
end
