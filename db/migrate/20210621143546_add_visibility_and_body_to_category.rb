# frozen_string_literal: true

# Migration to add visibility and body to categories table
class AddVisibilityAndBodyToCategory < ActiveRecord::Migration[6.1]
  def change
    change_table :categories, bulk: true do |t|
      t.integer :visibility, limit: 1, null: false, default: 0
      t.text :body, null: true
    end
  end
end
