# frozen_string_literal: true

# Menu item model
class MenuItem < ApplicationRecord
  TRANSLATABLE_FIELDS = %w[name].freeze

  include Translatable
  include Parentable

  belongs_to :menu, inverse_of: :menu_items
  belongs_to :linkable, polymorphic: true, optional: true
  belongs_to :parent, inverse_of: :children, class_name: 'MenuItem', optional: true, counter_cache: :children_count
  has_many :children, inverse_of: :parent, class_name: 'MenuItem', foreign_key: :parent_id, dependent: :destroy

  after_create :rearrange_siblings
  after_update :rearrange_siblings, if: -> { saved_change_to_parent_id? || saved_change_to_sort_order? }

  validates :name, presence: true, length: { maximum: 255 }
  validates :external_url, presence: true, unless: :linkable_id
  validate :valid_linkable, if: -> { (new_record? || will_save_change_to_linkable_id?) && linkable_id }

  private

  def valid_parent
    errors.add(:parent_id, :blank) if parent.nil? || parent.menu_id != menu_id
  end

  def valid_linkable
    errors.add(:linkable_id, :blank) if linkable.nil? || linkable.client_id != menu.client_id
  end

  def rearrange_siblings
    menu.with_lock do
      moved_up = saved_change_to_menu_id? || saved_change_to_parent_id? || sort_order <= sort_order_before_last_save

      menu.menu_items
          .where(parent_id:)
          .sort_by do |menu_item|
            if menu_item.id == id
              [sort_order, moved_up ? 0 : 2, id]
            else
              [menu_item.sort_order, 1, menu_item.id]
            end
          end.each.with_index(1) { |menu_item, index| menu_item.update_column(:sort_order, index) }
    end
  end
end
