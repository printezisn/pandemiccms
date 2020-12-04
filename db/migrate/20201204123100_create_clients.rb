# frozen_string_literal: true

# Migration to create clients table
class CreateClients < ActiveRecord::Migration[6.1]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :time_zone, null: false
      t.string :template, null: false
      t.text :settings

      t.timestamps null: false
    end
  end
end
