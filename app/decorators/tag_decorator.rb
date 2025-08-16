# frozen_string_literal: true

# Decorator for tag model
class TagDecorator < ApplicationDecorator
  delegate_all

  def path(language = nil)
    locale = language&.locale || I18n.locale

    Rails.application.routes.url_helpers.tag_path(
      id: object.id,
      slug: object.translate(locale, use_defaults: true).slug,
      locale:
    )
  end
end
