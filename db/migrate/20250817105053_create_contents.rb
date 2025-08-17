# frozen_string_literal: true

# Migration to add contents
class CreateContents < ActiveRecord::Migration[8.0]
  def change
    create_table :contents do |t|
      t.references :client, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :order, null: false, default: 0
      t.text :simple_text
      t.text :rich_text

      t.timestamps

      t.index %i[client_id name], unique: true, name: 'index_contents_on_client_id_and_name'
    end
  end
end
