# frozen_string_literal: true

# Module to add functionality around URL slugs
module Sluggable
  def displayed_slug
    return slug if slug.present? || name.blank?

    transliterate = :greek if /[\u0370-\u03FF\u1F00-\u1FFF]/.match?(name)

    name.to_slug.normalize(transliterate:).to_s
  end
end
