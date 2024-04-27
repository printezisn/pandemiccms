# frozen_string_literal: true

# Concern for adding tagging functionality to models
module Taggable
  extend ActiveSupport::Concern

  included do
    attribute :tag_names, default: -> { [] }
    attribute :should_save_tags, :boolean

    has_many :tag_taggables, as: :taggable, dependent: :destroy, inverse_of: :taggable
    has_many :tags, through: :tag_taggables

    after_save :save_tags, if: :should_save_tags
  end

  private

  def save_tags
    new_tags = tag_names.select(&:present?).map { |tag_name| Tag.find_or_initialize_by(name: tag_name, client_id:) }
    tag_taggables.each do |tag_taggable|
      tag_taggable.destroy unless new_tags.any? { |tag| tag.id == tag_taggable.tag_id }
    end

    self.tags = new_tags
  end
end
