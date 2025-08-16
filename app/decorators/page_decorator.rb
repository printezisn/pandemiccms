# frozen_string_literal: true

# Decorator for page model
class PageDecorator < ApplicationDecorator
  delegate_all

  def path(language = nil)
    locale = language&.locale || I18n.locale
    return Rails.application.routes.url_helpers.root_path(locale:) if object.template == 'index'

    Rails.application.routes.url_helpers.page_path(
      id: object.id,
      slug: object.translate(locale, use_defaults: true).displayed_slug,
      locale:
    )
  end
end
