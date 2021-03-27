# frozen_string_literal: true

# Migration to add columns to posts table
class AddColumnsToPost < ActiveRecord::Migration[6.1]
  def change
    change_table :posts, bulk: true do |t|
      t.string :slug
      t.text :description
      t.text :body
      t.string :template
      t.integer :status, limit: 1, null: false, default: 0
      t.integer :visibility, limit: 1, null: false, default: 0
      t.datetime :published_at
      t.references :author, null: false, foreign_key: { to_table: :admin_users }

      t.index %i[client_id name], unique: true
      t.index %i[client_id template]
      t.index %i[client_id status]
    end
  end
end
