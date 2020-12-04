# frozen_string_literal: true

# Migration to create media table
class CreateMedia < ActiveRecord::Migration[6.1]
  def change
    create_table :media do |t|
      t.references :client, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
