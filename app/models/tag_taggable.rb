# frozen_string_literal: true

# TagTaggable model
class TagTaggable < ApplicationRecord
  belongs_to :tag, inverse_of: :tag_taggables
  belongs_to :taggable, polymorphic: true

  after_destroy :update_tag_counters
  after_save :update_tag_counters

  scope :post, -> { where(taggable_type: 'Post') }
  scope :page, -> { where(taggable_type: 'Page') }

  private

  def update_tag_counters
    tag.update!(
      posts_count: tag.tag_taggables.post.count,
      pages_count: tag.tag_taggables.page.count
    )
  end
end
