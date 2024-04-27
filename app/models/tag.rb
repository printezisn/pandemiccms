# frozen_string_literal: true

# Tag model
class Tag < ApplicationRecord
  SORTABLE_FIELDS = %i[name created_at updated_at].freeze
  TEXT_SEARCHABLE_FIELDS = %i[name].freeze
  TRANSLATABLE_FIELDS = %w[name slug description body].freeze
  INDEXABLE_FIELDS_FOR_ASSOCIATIONS = %w[name visibility].freeze

  include SimpleTextSearchable
  include BoundSortable
  include Sluggable
  include Translatable

  after_update :index_associations, if: :should_index_associations?
  before_destroy :index_associations

  belongs_to :client, inverse_of: :tags

  has_many :tag_taggables, inverse_of: :tag, dependent: :destroy
  has_many :menu_items, as: :linkable, dependent: :destroy, inverse_of: :linkable

  enum visibility: {
    public: 0,
    private: 1
  }, _suffix: :visibility

  validates :name, presence: true,
                   length: { maximum: 255 },
                   uniqueness: { case_sensitive: false, scope: [:client_id] }
  validates :slug, length: { maximum: 255 }

  private

  def index_associations
    tag_taggables.post.each { |tag_taggable| tag_taggable.taggable.index }
  end

  def should_index_associations?
    previous_changes.keys.intersect?(INDEXABLE_FIELDS_FOR_ASSOCIATIONS)
  end
end
