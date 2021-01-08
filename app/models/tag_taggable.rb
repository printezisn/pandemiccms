# frozen_string_literal: true

class TagTaggable < ApplicationRecord
  belongs_to :tag, inverse_of: :tag_taggables
  belongs_to :taggable, polymorphic: true

  scope :post, -> { where(taggable_type: 'Post') }
  scope :page, -> { where(taggable_type: 'Page') }
end
