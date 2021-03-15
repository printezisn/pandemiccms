# frozen_string_literal: true

# Concern for adding tagging functionality to models
module Taggable
  extend ActiveSupport::Concern

  included do
    attribute :tag_names, default: []
    attribute :should_save_tags, :boolean

    has_many :tag_taggables, as: :taggable, dependent: :destroy
    has_many :tags, through: :tag_taggables

    after_save :save_tags, if: :should_save_tags
  end

  private

  def save_tags
    self.tags = tag_names.select(&:present?).map { |tag_name| Tag.find_or_initialize_by(name: tag_name, client_id: client_id) }
  end
end
