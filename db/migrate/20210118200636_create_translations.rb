# frozen_string_literal: true

# Migration to create translations table
class CreateTranslations < ActiveRecord::Migration[6.1]
  def change
    create_table :translations do |t|
      t.references :translatable, null: false, polymorphic: true
      t.string :locale, null: false
      t.text :fields

      t.timestamps null: false

      t.index %i[translatable_id translatable_type locale],
              name: 'index_translations_on_translatable_and_locale',
              unique: true
    end
  end
end
