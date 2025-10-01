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
    self.slug = Slugifier.new(name).call
  end
end
