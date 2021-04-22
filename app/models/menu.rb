# frozen_string_literal: true

# Menu model
class Menu < ApplicationRecord
  SORTABLE_FIELDS = %i[name created_at updated_at].freeze
  TEXT_SEARCHABLE_FIELDS = %i[name].freeze
  TRANSLATABLE_FIELDS = %w[name description].freeze

  include SimpleTextSearchable
  include BoundSortable
  include Translatable

  belongs_to :client, inverse_of: :menus

  validates :name, presence: true,
                   length: { maximum: 255 },
                   uniqueness: { case_sensitive: false, scope: [:client_id] }
end
