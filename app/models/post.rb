# frozen_string_literal: true

# Post model
class Post < ApplicationRecord
  SORTABLE_FIELDS = %i[name created_at updated_at].freeze
  TEXT_SEARCHABLE_FIELDS = %i[name].freeze
  TRANSLATABLE_FIELDS = %w[name slug description body].freeze

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
  has_many :menu_items, as: :linkable, dependent: :destroy

  enum visibility: {
    public: 0,
    private: 1
  }, _suffix: :visibility

  validates :name, presence: true,
                   length: { maximum: 255 },
                   uniqueness: { case_sensitive: false, scope: [:client_id] }
  validates :slug, length: { maximum: 255 }

  after_update :update_counters

  def visible?
    public_visibility? && published?
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
end
