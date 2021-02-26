# frozen_string_literal: true

# Migration to remove the pages_count column from tags table
class RemovePagesCountFromTag < ActiveRecord::Migration[6.1]
  def change
    remove_column :tags, :pages_count, :integer, null: false, default: 0
  end
end
