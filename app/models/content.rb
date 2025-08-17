# frozen_string_literal: true

# Content model
class Content < ApplicationRecord
  SORTABLE_FIELDS = %i[name order created_at updated_at].freeze
  TEXT_SEARCHABLE_FIELDS = %i[name].freeze
  TRANSLATABLE_FIELDS = %w[name simple_text rich_text].freeze

  include SimpleTextSearchable
  include BoundSortable
  include Translatable
  include Imageable
  include Categorizable

  belongs_to :client, inverse_of: :contents

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false, scope: :client_id }
  validates :order, presence: true, numericality: { only_integer: true }

  def text
    rich_text.presence || simple_text.presence || ''
  end
end
