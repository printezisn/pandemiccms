# frozen_string_literal: true

# Migration to add client to indexed entities table
class AddClientToIndexedEntities < ActiveRecord::Migration[7.1]
  def change
    change_table :indexed_entities, bulk: true do |t|
      t.references :client, null: false, foreign_key: true

      t.index %i[client_id locale indexable_type],
              name: 'index_indexed_entities_on_indexable_client_locale'
    end
  end
end
