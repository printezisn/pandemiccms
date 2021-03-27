# frozen_string_literal: true

# CategoryCategorizable model
class CategoryCategorizable < ApplicationRecord
  belongs_to :category, inverse_of: :category_categorizables
  belongs_to :categorizable, polymorphic: true

  after_create :increment_posts_count
  before_destroy :decrement_posts_count

  scope :post, -> { where(categorizable_type: 'Post') }

  private

  def increment_posts_count
    category.increment!(:posts_count) if post? && categorizable&.visible?
  end

  def decrement_posts_count
    category.decrement!(:posts_count) if post? && categorizable&.visible?
  end

  def post?
    categorizable_type == 'Post'
  end
end
