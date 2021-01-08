# frozen_string_literal: true

# Migration to create pages table
class CreatePages < ActiveRecord::Migration[6.1]
  def change
    create_table :pages do |t|
      t.references :client, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
