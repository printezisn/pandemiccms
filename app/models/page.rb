# frozen_string_literal: true

# Page model
class Page < ApplicationRecord
  SORTABLE_FIELDS = %i[name created_at].freeze
  TEXT_SEARCHABLE_FIELDS = %i[name].freeze
  TRANSLATABLE_FIELDS = %w[name slug description body].freeze

  include SimpleTextSearchable
  include BoundSortable
  include Sluggable
  include Translatable
  include Parentable
  include Imageable

  belongs_to :client, inverse_of: :pages
  belongs_to :author, class_name: 'AdminUser', inverse_of: :pages, optional: true
  belongs_to :parent, inverse_of: :children, class_name: 'Page', optional: true
  has_many :children, inverse_of: :parent, class_name: 'Page', foreign_key: :parent_id, dependent: :destroy
  has_many :tag_taggables, as: :taggable, dependent: :destroy
  has_many :tags, through: :tag_taggables

  enum status: {
    draft: 0,
    published: 1
  }

  enum visibility: {
    public: 0,
    private: 1
  }, _suffix: :visibility

  validates :name, presence: true,
                   length: { maximum: 255 },
                   uniqueness: { case_sensitive: false, scope: [:client_id] }
  validates :slug, length: { maximum: 255 }
end
