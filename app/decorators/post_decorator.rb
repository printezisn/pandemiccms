# frozen_string_literal: true

# Decorator for post model
class PostDecorator < ApplicationDecorator
  delegate_all

  def path(language = nil)
    Rails.application.routes.url_helpers.post_path(
      id: object.id,
      slug: object.displayed_slug(language&.transliterations),
      locale: language&.locale || I18n.default_locale
    )
  end
end
