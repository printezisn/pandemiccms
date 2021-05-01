# frozen_string_literal: true

# Migration to create menu_items table
class CreateMenuItems < ActiveRecord::Migration[6.1]
  def change
    create_table :menu_items do |t|
      t.string :name, null: false
      t.integer :sort_order, null: false, default: 1
      t.text :external_url
      t.references :menu, null: false, foreign_key: true
      t.references :linkable, polymorphic: true
      t.references :parent, foreign_key: { to_table: :menu_items }
      t.text :hierarchy_path
      t.integer :children_count, null: false, default: 0

      t.timestamps
    end
  end
end
