# frozen_string_literal: true

# Migration to create email templates table
class CreateEmailTemplates < ActiveRecord::Migration[6.1]
  def change
    create_table :email_templates do |t|
      t.references :client, null: false, foreign_key: true
      t.string :type, null: false
      t.string :subject
      t.text :body

      t.timestamps

      t.index %i[client_id type]
    end
  end
end
