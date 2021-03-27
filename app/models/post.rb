# frozen_string_literal: true

# Post model
class Post < ApplicationRecord
  SORTABLE_FIELDS = %i[name created_at].freeze
  TEXT_SEARCHABLE_FIELDS = %i[name].freeze
  TRANSLATABLE_FIELDS = %w[name slug description body].freeze

  include SimpleTextSearchable
  include BoundSortable
  include Sluggable
  include Translatable
  include Imageable
  include Categorizable
  include Taggable
  include Draftable

  belongs_to :client, inverse_of: :pages
  belongs_to :author, class_name: 'AdminUser', inverse_of: :pages, optional: true

  enum visibility: {
    public: 0,
    private: 1
  }, _suffix: :visibility

  validates :name, presence: true,
                   length: { maximum: 255 },
                   uniqueness: { case_sensitive: false, scope: [:client_id] }
  validates :slug, length: { maximum: 255 }

  def visible?
    public_visibility? && published?
  end
end
