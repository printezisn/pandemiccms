# frozen_string_literal: true

# Module to add functionality around URL slugs
module Sluggable
  def displayed_slug(transliterations)
    return slug if slug.present? || name.blank?

    name.to_slug.normalize(transliterations: transliterations&.to_sym).to_s
  end
end
