# frozen_string_literal: true

# TagTaggable model
class TagTaggable < ApplicationRecord
  belongs_to :tag, inverse_of: :tag_taggables
  belongs_to :taggable, polymorphic: true

  after_create :increase_posts_count, if: :post?
  after_create :increase_pages_count, if: :page?
  after_destroy :decrease_posts_count, if: :post?
  after_destroy :decrease_pages_count, if: :page?

  scope :post, -> { where(taggable_type: 'Post') }
  scope :page, -> { where(taggable_type: 'Page') }

  private

  def post?
    taggable_type == 'Post'
  end

  def page?
    taggable_type == 'Page'
  end

  def increase_posts_count
    tag.increment!(:posts_count)
  end

  def decrease_posts_count
    Tag.find_by(id: tag_id)&.decrement!(:posts_count)
  end

  def increase_pages_count
    tag.increment!(:pages_count)
  end

  def decrease_pages_count
    Tag.find_by(id: tag_id)&.decrement!(:pages_count)
  end
end
