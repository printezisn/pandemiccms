# frozen_string_literal: true

# Migration to add children_count column to categories
class AddChildrenCountToCategory < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :children_count, :integer, default: 0
  end
end
