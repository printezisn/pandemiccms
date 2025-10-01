# frozen_string_literal: true

# Page model
class Page < ApplicationRecord
  SORTABLE_FIELDS = %i[name created_at updated_at].freeze
  TEXT_SEARCHABLE_FIELDS = %i[name].freeze
  TRANSLATABLE_FIELDS = %w[name slug description body image_description meta_title meta_description].freeze

  include SimpleTextSearchable
  include BoundSortable
  include Sluggable
  include Translatable
  include Parentable
  include Imageable
  include Taggable
  include Draftable

  belongs_to :client, inverse_of: :pages
  belongs_to :author, class_name: 'AdminUser', inverse_of: :pages, optional: true
  belongs_to :parent, inverse_of: :children, class_name: 'Page', optional: true, counter_cache: :children_count
  has_many :children, inverse_of: :parent, class_name: 'Page', foreign_key: :parent_id, dependent: :destroy
  has_many :menu_items, as: :linkable, dependent: :destroy, inverse_of: :linkable

  enum :visibility, {
    public: 0,
    private: 1
  }, suffix: :visibility

  validates :name, presence: true,
                   length: { maximum: 255 },
                   uniqueness: { case_sensitive: false, scope: [:client_id] }
  validates :slug, length: { maximum: 255 }
  validates :image_description, length: { maximum: 255 }
  validates :meta_title, length: { maximum: 60 }
  validates :meta_description, length: { maximum: 160 }

  def visible?
    public_visibility? && published?
  end
end
