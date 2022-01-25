# frozen_string_literal: true

# Concern to add hierarchy functionality to models
module Parentable
  extend ActiveSupport::Concern

  included do
    validate :valid_parent, if: -> { (new_record? || will_save_change_to_parent_id?) && parent_id }
    validate :valid_hierarchy, if: -> { (new_record? || will_save_change_to_parent_id?) && parent }

    before_save :set_hierarchy_path, if: -> { new_record? || will_save_change_to_parent_id? }
    after_save :update_children_hierarchy_path, if: :saved_change_to_hierarchy_path?
    before_destroy :detach_children

    scope :descendants_of, lambda { |instance|
      path = (instance.ancestor_ids + [instance.id]).join(',')

      where(hierarchy_path: path).or(where(arel_table[:hierarchy_path].matches("#{path},%")))
    }

    def self.ordered_by_hierarchy(scope, sort_field = :name)
      models = scope.to_a
      models.sort_by do |instance|
        ancestors = models.select { |ancestor| instance.ancestor_ids.include?(ancestor.id) }
                          .sort_by { |ancestor| instance.ancestor_ids.index(ancestor.id) }
        (ancestors + [instance]).map(&sort_field)
      end
    end
  end

  def ancestor_ids
    return @ancestor_ids if defined?(@ancestor_ids) && memoized?

    @hierarchy_path = hierarchy_path
    @ancestor_ids = fetch_ancestor_ids
  end

  def ancestors
    return @ancestors if defined?(@ancestors) && memoized?

    @ancestors = self.class.where(id: ancestor_ids).sort_by { |ancestor| ancestor_ids.index(ancestor.id) }
  end

  def descendants
    return @descendants if defined?(@descendants) && memoized?

    @descendants = fetch_descendants
  end

  def depth
    ancestor_ids.size
  end

  def name_with_depth
    return name if depth.zero?

    "#{Array.new(depth) { '--' }.join} #{name}"
  end

  private

  def valid_parent
    errors.add(:parent_id, :blank) if parent.nil? || parent.client_id != client_id
  end

  def valid_hierarchy
    errors.add(:parent_id, :circle) if parent.id == id || parent.ancestor_ids.include?(id)
  end

  def fetch_ancestor_ids
    return [] if hierarchy_path.blank?

    hierarchy_path.split(',').map(&:to_i)
  end

  def fetch_descendants
    hierarchy_path = (ancestor_ids + [id]).join(',')
    self.class.where(hierarchy_path:).or(
      self.class.where(self.class.arel_table[:hierarchy_path].matches("#{hierarchy_path},%"))
    )
  end

  def set_hierarchy_path
    self.hierarchy_path = if parent.nil?
                            nil
                          else
                            (parent.ancestor_ids + [parent_id]).join(',')
                          end
  end

  def update_children_hierarchy_path
    children.each { |child| child.update!(hierarchy_path: (ancestor_ids + [id]).join(',')) }
  end

  def detach_children
    children.each { |child| child.update!(parent_id: nil) }
  end

  def memoized?
    defined?(@hierarchy_path) && @hierarchy_path != hierarchy_path
  end
end
