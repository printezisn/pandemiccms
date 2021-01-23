# frozen_string_literal: true

# Migration to add enabled column to client_languages table
class AddEnabledToClientLanguage < ActiveRecord::Migration[6.1]
  def change
    add_column :client_languages, :enabled, :boolean
  end
end
