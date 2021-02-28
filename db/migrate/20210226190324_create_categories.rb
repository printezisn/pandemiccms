# frozen_string_literal: true

# Migration to create categories table
class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.references :client, null: false, foreign_key: true
      t.string :name, null: false
      t.string :slug
      t.text :description
      t.string :template
      t.integer :posts_count, null: false, default: 0
      t.references :parent, foreign_key: { to_table: :categories }
      t.text :hierarchy_path

      t.timestamps null: false

      t.index %i[client_id name], unique: true
      t.index %i[client_id posts_count]
    end
  end
end
