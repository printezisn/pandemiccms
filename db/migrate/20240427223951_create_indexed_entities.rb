# frozen_string_literal: true

# Migration to create indexed entities table
class CreateIndexedEntities < ActiveRecord::Migration[7.1]
  def change
    create_table :indexed_entities do |t|
      t.references :indexable, polymorphic: true, null: false
      t.string :locale, null: false
      t.text :text

      t.timestamps null: false

      t.index %i[indexable_id indexable_type locale],
              name: 'index_indexed_entities_on_indexable_and_locale',
              unique: true
    end
  end
end
