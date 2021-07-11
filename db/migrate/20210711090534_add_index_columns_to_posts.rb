# frozen_string_literal: true

# Migration to add search index-related columns to posts table
class AddIndexColumnsToPosts < ActiveRecord::Migration[6.1]
  def change
    change_table :posts, bulk: true do |t|
      t.datetime :indexed_at
      t.string :index_version

      t.index :indexed_at
    end
  end
end
