# frozen_string_literal: true

# Migration to create client languages table
class CreateClientLanguages < ActiveRecord::Migration[6.1]
  def change
    create_table :client_languages do |t|
      t.references :client, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true
      t.boolean :default, null: false, default: false

      t.timestamps null: false

      t.index %i[client_id language_id], unique: true
    end
  end
end
