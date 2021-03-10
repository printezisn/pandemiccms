# frozen_string_literal: true

# Category model
class Category < ApplicationRecord
  SORTABLE_FIELDS = %i[created_at name].freeze
  TEXT_SEARCHABLE_FIELDS = %i[name].freeze
  TRANSLATABLE_FIELDS = %w[name slug description].freeze

  include SimpleTextSearchable
  include BoundSortable
  include Sluggable
  include Translatable
  include Parentable
  include Imageable

  belongs_to :client, inverse_of: :categories
  belongs_to :parent, inverse_of: :children, class_name: 'Category', optional: true
  has_many :children, inverse_of: :parent, class_name: 'Category', foreign_key: :parent_id, dependent: :destroy
  has_many :category_categorizables, inverse_of: :category, dependent: :destroy

  validates :name, presence: true,
                   length: { maximum: 255 },
                   uniqueness: { case_sensitive: false, scope: [:client_id] }
  validates :slug, length: { maximum: 255 }
end
