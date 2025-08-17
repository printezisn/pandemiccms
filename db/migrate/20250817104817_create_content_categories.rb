# frozen_string_literal: true

# Migration to add content categories
class CreateContentCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :content_categories do |t|
      t.references :client, null: false, foreign_key: true
      t.string :name, null: false
      t.string :description

      t.timestamps

      t.index %i[client_id name], unique: true, name: 'index_content_categories_on_client_id_and_name'
    end
  end
end
