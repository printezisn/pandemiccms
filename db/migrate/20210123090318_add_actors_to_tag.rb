# frozen_string_literal: true

# Migration to add actor columns to tags table
class AddActorsToTag < ActiveRecord::Migration[6.1]
  def change
    change_table :tags, bulk: true do |t|
      t.references :creator, null: false, foreign_key: { to_table: :admin_users }
      t.references :updater, null: false, foreign_key: { to_table: :admin_users }
    end
  end
end
