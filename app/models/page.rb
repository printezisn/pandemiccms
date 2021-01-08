# frozen_string_literal: true

# Page model
class Page < ApplicationRecord
  SORTABLE_FIELDS = %i[created_at name].freeze
  TEXT_SEARCHABLE_FIELDS = %i[name].freeze

  include SimpleTextSearchable
  include BoundSortable

  belongs_to :client, inverse_of: :pages

  has_many :tag_taggables, as: :taggable, dependent: :destroy
  has_many :tags, through: :tag_taggables
end
