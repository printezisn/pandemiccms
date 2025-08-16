# frozen_string_literal: true

# Module to add functionality around URL slugs
module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :generate_slug, if: :should_generate_slug?
  end

  private

  def should_generate_slug?
    slug.blank? && name.present?
  end

  def generate_slug
    transliterate = :greek if /[\u0370-\u03FF\u1F00-\u1FFF]/.match?(name)
    self.slug = name.to_slug.normalize(transliterate:).to_s
  end
end
