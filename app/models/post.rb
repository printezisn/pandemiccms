# frozen_string_literal: true

# Post model
class Post < ApplicationRecord
  SORTABLE_FIELDS = %i[created_at name].freeze
  TEXT_SEARCHABLE_FIELDS = %i[name].freeze

  include SimpleTextSearchable
  include BoundSortable

  belongs_to :client, inverse_of: :posts

  has_many :tag_taggables, as: :taggable, dependent: :destroy
  has_many :tags, through: :tag_taggables
  has_many :category_categorizables, as: :categorizable, dependent: :destroy
  has_many :categories, through: :category_categorizables
end
