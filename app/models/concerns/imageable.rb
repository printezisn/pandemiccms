# frozen_string_literal: true

# Concern for adding image attachment to models
module Imageable
  extend ActiveSupport::Concern

  included do
    has_one_attached :image
    attribute :should_remove_image, :boolean

    before_validation :remove_image, if: -> { should_remove_image && image.attached? }
    validate :valid_image, if: -> { image.attached? }
  end

  private

  def remove_image
    image.purge
  end

  def valid_image
    errors.add(:image, :invalid_image) unless image.image?
  end
end
