# frozen_string_literal: true

# Content category model
class ContentCategory < ApplicationRecord
  SORTABLE_FIELDS = %i[name created_at updated_at].freeze
  TEXT_SEARCHABLE_FIELDS = %i[name].freeze

  include SimpleTextSearchable
  include BoundSortable

  belongs_to :client, inverse_of: :content_categories
  has_many :content_category_contents, inverse_of: :content_category, dependent: :destroy
  has_many :contents, through: :content_category_contents

  validates :name, presence: true,
                   length: { maximum: 255 },
                   uniqueness: { case_sensitive: false, scope: [:client_id] }
  validates :description, length: { maximum: 255 }
end
