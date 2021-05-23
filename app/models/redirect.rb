# frozen_string_literal: true

# Redirect model
class Redirect < ApplicationRecord
  SORTABLE_FIELDS = %i[from to created_at updated_at].freeze
  TEXT_SEARCHABLE_FIELDS = %i[from to].freeze

  include SimpleTextSearchable
  include BoundSortable

  belongs_to :client, inverse_of: :redirects

  validates :from, presence: true
  validates :to, presence: true
end
