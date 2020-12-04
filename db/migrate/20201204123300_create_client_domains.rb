# frozen_string_literal: true

# Migration to create the client domains table
class CreateClientDomains < ActiveRecord::Migration[6.1]
  def change
    create_table :client_domains do |t|
      t.references :client, null: false, foreign_key: true
      t.string :domain, null: false
      t.integer :port, null: false

      t.timestamps null: false

      t.index %i[domain port], unique: true
    end
  end
end
