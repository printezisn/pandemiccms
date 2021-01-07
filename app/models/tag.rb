# frozen_string_literal: true

# Tag model
class Tag < ApplicationRecord
  SORTABLE_FIELDS = %i[created_at name posts_count pages_count].freeze
  TEXT_SEARCHABLE_FIELDS = %i[name].freeze

  include SimpleTextSearchable
  include BoundSortable

  belongs_to :client, inverse_of: :tags

  validates :name, presence: true,
                   length: { maximum: 255 },
                   uniqueness: { case_sensitive: false, scope: [:client_id] }
  validates :slug, length: { maximum: 255 }
end
