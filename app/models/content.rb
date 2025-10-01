# frozen_string_literal: true

# Content model
class Content < ApplicationRecord
  SORTABLE_FIELDS = %i[name order created_at updated_at].freeze
  TEXT_SEARCHABLE_FIELDS = %i[name].freeze
  TRANSLATABLE_FIELDS = %w[name title simple_text rich_text image_description].freeze

  include SimpleTextSearchable
  include BoundSortable
  include Translatable
  include Imageable
  include Categorizable

  belongs_to :client, inverse_of: :contents

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false, scope: :client_id }
  validates :order, presence: true, numericality: { only_integer: true }
  validates :image_description, length: { maximum: 255 }
  validates :title, length: { maximum: 255 }

  def title_or_name
    title.presence || name
  end

  def text
    rich_text.presence || simple_text.presence || ''
  end

  def to_slug
    Slugifier.new(title_or_name).call
  end
end
