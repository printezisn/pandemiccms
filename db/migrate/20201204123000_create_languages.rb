# frozen_string_literal: true

# Migration to create languages table
class CreateLanguages < ActiveRecord::Migration[6.1]
  def change
    create_table :languages do |t|
      t.string :locale, null: false
      t.string :name, null: false
      t.string :flag, limit: 10, null: false

      t.timestamps null: false

      t.index :locale, unique: true
    end
  end
end
