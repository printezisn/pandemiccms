# frozen_string_literal: true

# Post model
class Post < ApplicationRecord
  SORTABLE_FIELDS = %i[name created_at updated_at].freeze
  TEXT_SEARCHABLE_FIELDS = %i[name].freeze
  TRANSLATABLE_FIELDS = %w[name slug description body image_description meta_title meta_description].freeze
  INDEXABLE_FIELDS = %w[name description body visibility status].freeze

  include SimpleTextSearchable
  include BoundSortable
  include Sluggable
  include Translatable
  include Imageable
  include Categorizable
  include Taggable
  include Draftable

  belongs_to :client, inverse_of: :posts
  belongs_to :author, class_name: 'AdminUser', inverse_of: :posts, optional: true
  has_many :menu_items, as: :linkable, dependent: :destroy, inverse_of: :linkable
  has_many :indexed_entities, as: :indexable, dependent: :destroy, inverse_of: :indexable

  enum :visibility, {
    public: 0,
    private: 1
  }, suffix: :visibility

  validates :name, presence: true,
                   length: { maximum: 255 },
                   uniqueness: { case_sensitive: false, scope: [:client_id] }
  validates :slug, length: { maximum: 255 }
  validates :image_description, length: { maximum: 255 }
  validates :meta_title, length: { maximum: 60 }
  validates :meta_description, length: { maximum: 160 }

  before_save :reset_indexed_at, if: :should_index?

  after_update :update_counters
  after_commit :create_index_job, on: %i[create update], if: -> { indexed_at.nil? }
  after_commit :unindex, on: :destroy

  def visible?
    public_visibility? && published?
  end

  def index
    update!(indexed_at: nil)
  end

  private

  def update_counters
    was_visible = status_before_last_save == 'published' && visibility_before_last_save == 'public'

    if visible? && !was_visible
      categories.each { |category| category.increment!(:posts_count) }
      tags.each { |tag| tag.increment!(:posts_count) }
    elsif !visible? && was_visible
      categories.each { |category| category.decrement!(:posts_count) }
      tags.each { |tag| tag.decrement!(:posts_count) }
    end
  end

  def reset_indexed_at
    self.indexed_at = nil
  end

  def should_index?
    new_record? || should_save_tags? || should_save_categories? || changes.keys.intersect?(INDEXABLE_FIELDS)
  end

  def unindex
    UnindexJob.perform_later(self.class, client_id, id)
  end

  def create_index_job
    IndexJob.perform_later(self.class, id)
  end
end
