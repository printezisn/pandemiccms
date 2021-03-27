# frozen_string_literal: true

# Migration to add children_count column to page
class AddChildrenCountToPage < ActiveRecord::Migration[6.1]
  def change
    add_column :pages, :children_count, :integer, default: 0
  end
end
