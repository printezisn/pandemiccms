# frozen_string_literal: true

# Migration to add visibility and body to tags table
class AddVisibilityAndBodyToTag < ActiveRecord::Migration[6.1]
  def change
    change_table :tags, bulk: true do |t|
      t.integer :visibility, limit: 1, null: false, default: 0
      t.text :body, null: true
    end
  end
end
