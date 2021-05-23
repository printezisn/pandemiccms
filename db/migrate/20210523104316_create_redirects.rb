# frozen_string_literal: true

# Migration to create redirects table
class CreateRedirects < ActiveRecord::Migration[6.1]
  def change
    create_table :redirects do |t|
      t.references :client, null: false, foreign_key: true
      t.text :from
      t.text :to

      t.timestamps
    end
  end
end
