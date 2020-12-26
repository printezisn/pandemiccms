# frozen_string_literal: true

# Migration to create media table
class CreateMedia < ActiveRecord::Migration[6.1]
  def change
    create_table :media do |t|
      t.string :client_id, null: false
      t.string :name, null: false

      t.timestamps null: false
    end

    add_index :media, :client_id
  end
end
