# frozen_string_literal: true

# Decorator for client model
class ClientDecorator < ApplicationDecorator
  delegate_all

  def image_path_with_default(size, default_path = '/logo.png')
    return default_path unless client.image.attached?

    Rails.application.routes.url_helpers.rails_representation_url(
      client.image.variant(resize_to_limit: size),
      only_path: true,
      locale: nil
    )
  end
end
