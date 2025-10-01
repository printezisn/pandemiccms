# frozen_string_literal: true

# Category model
class Category < ApplicationRecord
  SORTABLE_FIELDS = %i[name created_at updated_at].freeze
  TEXT_SEARCHABLE_FIELDS = %i[name].freeze
  TRANSLATABLE_FIELDS = %w[name slug description body image_description meta_title meta_description].freeze
  INDEXABLE_FIELDS_FOR_ASSOCIATIONS = %w[name visibility].freeze

  include SimpleTextSearchable
  include BoundSortable
  include Sluggable
  include Translatable
  include Parentable
  include Imageable

  after_update :index_associations, if: :should_index_associations?
  before_destroy :index_associations

  belongs_to :client, inverse_of: :categories
  belongs_to :parent, inverse_of: :children, class_name: 'Category', optional: true, counter_cache: :children_count
  has_many :children, inverse_of: :parent, class_name: 'Category', foreign_key: :parent_id, dependent: :destroy
  has_many :category_categorizables, inverse_of: :category, dependent: :destroy
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

  private

  def index_associations
    category_categorizables.post.each do |category_categorizable|
      category_categorizable.categorizable.index
    end
  end

  def should_index_associations?
    previous_changes.keys.intersect?(INDEXABLE_FIELDS_FOR_ASSOCIATIONS)
  end
end
