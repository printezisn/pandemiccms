# frozen_string_literal: true

# Tag model
class Tag < ApplicationRecord
  SORTABLE_FIELDS = %i[created_at name posts_count pages_count].freeze
  TEXT_SEARCHABLE_FIELDS = %i[name].freeze
  TRANSLATABLE_FIELDS = %w[name slug description].freeze

  include SimpleTextSearchable
  include BoundSortable
  include Sluggable
  include Translatable

  belongs_to :client, inverse_of: :tags
  belongs_to :creator, class_name: 'AdminUser', inverse_of: :created_tags
  belongs_to :updater, class_name: 'AdminUser', inverse_of: :updated_tags

  has_many :tag_taggables, inverse_of: :tag, dependent: :destroy

  validates :name, presence: true,
                   length: { maximum: 255 },
                   uniqueness: { case_sensitive: false, scope: [:client_id] }
  validates :slug, length: { maximum: 255 }
end
