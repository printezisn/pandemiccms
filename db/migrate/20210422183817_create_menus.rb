# frozen_string_literal: true

# Migration to create menus table
class CreateMenus < ActiveRecord::Migration[6.1]
  def change
    create_table :menus do |t|
      t.string :name, null: false
      t.references :client, null: false, foreign_key: true
      t.text :description

      t.timestamps

      t.index %i[client_id name], unique: true
    end
  end
end
