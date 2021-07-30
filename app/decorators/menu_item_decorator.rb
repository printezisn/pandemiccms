# frozen_string_literal: true

# Decorator for menu item model
class MenuItemDecorator < ApplicationDecorator
  delegate_all

  decorates_association :linkable

  def path(language)
    return object.external_url unless linkable

    linkable.path(language)
  end
end
