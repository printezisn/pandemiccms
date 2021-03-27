# frozen_string_literal: true

# TagTaggable model
class TagTaggable < ApplicationRecord
  belongs_to :tag, inverse_of: :tag_taggables
  belongs_to :taggable, polymorphic: true

  after_create :increment_posts_count
  before_destroy :decrement_posts_count

  scope :post, -> { where(taggable_type: 'Post') }
  scope :page, -> { where(taggable_type: 'Page') }

  private

  def increment_posts_count
    tag.increment!(:posts_count) if post? && taggable&.visible?
  end

  def decrement_posts_count
    tag.decrement!(:posts_count) if post? && taggable&.visible?
  end

  def post?
    taggable_type == 'Post'
  end

  def page?
    taggable_type == 'Page'
  end
end
