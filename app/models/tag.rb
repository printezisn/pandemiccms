# frozen_string_literal: true

# Tag model
class Tag < ApplicationRecord
  SORTABLE_FIELDS = %i[name created_at updated_at].freeze
  TEXT_SEARCHABLE_FIELDS = %i[name].freeze
  TRANSLATABLE_FIELDS = %w[name slug description body].freeze

  include SimpleTextSearchable
  include BoundSortable
  include Sluggable
  include Translatable

  belongs_to :client, inverse_of: :tags

  has_many :tag_taggables, inverse_of: :tag, dependent: :destroy
  has_many :menu_items, as: :linkable, dependent: :destroy

  enum visibility: {
    public: 0,
    private: 1
  }, _suffix: :visibility

  validates :name, presence: true,
                   length: { maximum: 255 },
                   uniqueness: { case_sensitive: false, scope: [:client_id] }
  validates :slug, length: { maximum: 255 }
end
